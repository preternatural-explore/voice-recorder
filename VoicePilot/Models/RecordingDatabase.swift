//
//  RecordingDatabase.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/27/24.
//

import SwiftData
import Foundation
import OpenAI

final class RecordingDatabase: ObservableObject {
    
    let container: ModelContainer
    
    @Published private(set) var recordings: [Recording] = []
    
    init(useInMemoryStore: Bool = false) throws {
        
        let schema = Schema([
            Recording.self,
            RecordingSegment.self,
            RecordingKeyPoint.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: useInMemoryStore)
        
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
        recordings = self.fetchRecordings()
    }
    
    private func fetchRecordings() -> [Recording] {
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<Recording>(sortBy: [SortDescriptor(\.createdDate, order: .reverse)])
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print(error)
        }
        
        return []
    }
    
    @MainActor
    func create(_ recording: Recording) async throws {
        let context = ModelContext(container)
        context.insert(recording)
        do {
            try context.save()
            await MainActor.run {
                recordings = self.fetchRecordings()
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func delete(_ recording: Recording) async throws {
        do {
            let context = ModelContext(container)
            let recordingToDelete = context.model(for: recording.persistentModelID)
            context.delete(recordingToDelete)
            try context.save()
            recordings = self.fetchRecordings()
        } catch {
            print(error)
        }
    }
    
    func transcribeRecordings() {
        let context = ModelContext(container)
        let untranscribedRecordings = FetchDescriptor<Recording>(predicate: #Predicate { recording in
            recording.isTranscribed == false
        })
        do {
            try context.enumerate(untranscribedRecordings) { recording in
                // use OpenAI API
                let transcriptionManager = TranscriptionCreationManager(recording: recording, recordingDatabase: self)
                Task(priority: .userInitiated) {
                    await transcriptionManager.getTranscription()
                    await TranscriptionAnalysisManager.getAnalysisForRecording(recording, recordingDatabase: self)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func analyzeRecordings() {
        let context = ModelContext(container)
        let unanlyzedRecordings = FetchDescriptor<Recording>(predicate: #Predicate { recording in
            recording.isAnalyzed == false
        })
        do {
            try context.enumerate(unanlyzedRecordings) { recording in
                Task(priority: .userInitiated) {
                    await TranscriptionAnalysisManager.getAnalysisForRecording( recording, recordingDatabase: self)
                }
            }
        } catch {
            print(error)
        }
    }
    
//    // OpenAI Transcription
    func processTranscription(
        _ transcription: OpenAI.AudioTranscription,
        forRecording recording: Recording)
    async {
        let context = ModelContext(container)
        let recordingToUpdate = context.model(for: recording.persistentModelID) as! Recording
        recordingToUpdate.transcriptionData = Data(transcription.text.utf8)
        recordingToUpdate.isTranscribed = true
        recordingToUpdate.language = transcription.language
        recordingToUpdate.duration = transcription.duration
       
        if let segments = transcription.segments {
            let recordingSegments = segments.map {
                RecordingSegment(segment: $0)
            }
            recordingToUpdate.segments = recordingSegments
        }
        
        context.insert(recordingToUpdate)
        
        do {
            try context.save()
            await TranscriptionAnalysisManager.getAnalysisForRecording(recordingToUpdate, recordingDatabase: self)
            await MainActor.run {
                recordings = self.fetchRecordings()
            }
        } catch {
            print(error)
        }
        
    }
    
    @MainActor
    func processRecordingAnalysis(
        _ recordingAnalysis: TranscriptionAnalysisPromptManager.AddRecordingResult.RecordingAnalysis,
        forRecording recording: Recording)
    async {
        let context = ModelContext(container)
        let recordingToUpdate = context.model(for: recording.persistentModelID) as! Recording
        
        recordingToUpdate.isAnalyzed = true
        recordingToUpdate.title = recordingAnalysis.title
        recordingToUpdate.summary = recordingAnalysis.summary
        
        let keyPoints = recordingAnalysis.keypoints.map {
            RecordingKeyPoint(keyPoint: $0)
        }
        
        recordingToUpdate.keyPoints = keyPoints
        context.insert(recordingToUpdate)
        
        do {
            try context.save()
            await MainActor.run {
                recordings = self.fetchRecordings()
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func processRecordingAnalysiFailure(
        _ assistantReply: PromptLiteral,
        forRecording recording: Recording)
    async {
        let context = ModelContext(container)
        let recordingToUpdate = context.model(for: recording.persistentModelID) as! Recording
        
        recordingToUpdate.isAnalyzed = true
        recordingToUpdate.title = "Unable to Analyze This Recording"
        recordingToUpdate.summary = assistantReply.description

        context.insert(recordingToUpdate)
        
        do {
            try context.save()
            await MainActor.run {
                recordings = self.fetchRecordings()
            }
        } catch {
            print(error)
        }
    }
}
