//
//  RecordedSegementModel.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/25/24.
//

import SwiftData
import Foundation
import OpenAI

@Model
class RecordingSegment {
    
    @Attribute(.unique) var id: UUID
    let segmentIndex: Int
    let startTime: Float
    let endTime: Float
    let textData: Data
    let seek: Int
    
    init(segment: OpenAI.AudioTranscription.TranscriptionSegment) {
        self.id = UUID()
        self.segmentIndex = segment.id
        self.startTime = Float(segment.start)
        self.endTime = Float(segment.end)
        self.textData = Data(segment.text.utf8)
        self.seek = segment.seek
    }
}

extension RecordingSegment {
    
    var text: String {
        return String(data: textData, encoding: .utf8) ?? ""
    }
    
    var formattedTimestampText: String {
        return "[\(formatTimestamp(startTime)) - \(formatTimestamp(endTime))] "
    }
    
    private func formatTimestamp(_ timestamp: Float) -> String {
        return String(format: "%.2f", timestamp)
    }
}
