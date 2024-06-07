//
//  RecordingKeyPoints.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/26/24.
//

import SwiftData

@Model
class RecordingKeyPoint {
    
    let text: String
        
    init(keyPoint: String) {
        self.text = keyPoint
    }
}
