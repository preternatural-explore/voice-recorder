//
//  RecordedObjectModel.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/17/24.
//

import SwiftData
import Foundation

@Model
class Recording {
    
    @Attribute(.unique) var id: UUID
    let audioData: Data
    let createdDate: Date
    var title: String
    
    var isTranscribed: Bool = false
    var transcriptionData: Data?
    var language: String?
    var duration: Double?
    @Relationship(deleteRule: .cascade) var segments: [RecordingSegment]?
    
    var isAnalyzed: Bool = false
    var summary: String?
    @Relationship(deleteRule: .cascade) var keyPoints: [RecordingKeyPoint]?
    
    init(audioData: Data) {
        self.id = UUID()
        self.audioData = audioData
        self.createdDate = Date.now
        self.title = "New Recording"
    }
}

extension Recording {
    
    var urlToPlay: URL? {
        do {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Failed to get the documents directory")
                return nil
            }
            
            #if os(iOS)
            let fileURL = directory.appendingPathComponent("\(id).mp4")
            #elseif os(macOS)
            let fileURL = directory.appendingPathComponent("\(id).ccp")
            #endif
            try audioData.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            print("Failed to write data: \(error)")
            return nil
        }
    }
    
    var urlToTranscribe: URL? {
        do {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Failed to get the documents directory")
                return nil
            }
            
            let fileURL = directory.appendingPathComponent("transcribe.wav")

            try audioData.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            print("Failed to write data: \(error)")
            return nil
        }
    }
    
    var transcription: String? {
        if let transcriptionData = transcriptionData {
            return String(data: transcriptionData, encoding: .utf8)
        }
        
        return nil
    }
    
    var orderedSegments: [RecordingSegment]? {
        if let segments = segments {
            return segments.sorted { $0.startTime < $1.startTime }
        }
        return nil
    }
}
