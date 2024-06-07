//
//  AIManager.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 5/4/24.
//

import OpenAI

struct AIClientManager {
    
    static let client = OpenAI.APIClient(
        apiKey: "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"
    )
    
    static let chatModel = OpenAI.Model.chat(.gpt_4_turbo)
    
    static let tokenLimit = 4096
}
