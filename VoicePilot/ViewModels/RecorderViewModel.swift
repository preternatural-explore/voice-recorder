//
//  RecordingViewModel.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/15/24.
//

import Media
import SwiftUI
import SwiftData

class RecorderViewModel: ObservableObject {
    
    let recorder = AudioRecorder()
    
    private let recordingDatabase: RecordingDatabase
    
    @Published private(set) var isRecording: Bool = false
    
    init(recordingDatabase: RecordingDatabase) {
        self.recordingDatabase = recordingDatabase
    }
    
    @MainActor
    func startRecording() async {
        do {
            try await recorder.prepare()
            try await recorder.record()
            isRecording = true
        } catch {
            print(error)
        }
    }
    
   @MainActor
    func stopRecording() async {
        do {
            try await recorder.stop()
            isRecording = false
            await processRecording()
        } catch {
            print(error)
        }
    }
    
    private func processRecording() async {
        do {
            if let recordingData = try recorder.recording?.data() {
                
                let recording = Recording(audioData: recordingData)
                try await recordingDatabase.create(recording)
                
                //using the OpenAI Whisper API
                Task(priority: .userInitiated) {
                    let transcriptionManager = TranscriptionCreationManager(recording: recording, recordingDatabase: recordingDatabase)
                    await transcriptionManager.getTranscription()
                }
            }
            
        } catch {
            print(error)
        }
    }
}
