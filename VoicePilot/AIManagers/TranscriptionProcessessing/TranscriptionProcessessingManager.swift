//
//  TranscriptionProcessessingManager.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 5/4/24.
//

import OpenAI

struct TranscriptionProcessessingManager {
        
    private let client = AIClientManager.client
    
    let transcription: OpenAI.AudioTranscription
    let recording: Recording
    let recordingDatabase: RecordingDatabase
    
    
    private let systemPrompt: String =
        """
        You are a highly skilled AI trained in language comprehension and grammar.
        
        You will be given a text of an audio transcription. Your job is to seperate it into paragraphs and include correct punctuation, and make any grammar adjustments as needed.
        
        Aim to retain as much of the original transcription as possible, only break it up into paragraphs with correct grammar to help a person easily read the transcription.
        
        Please avoid unnecessary details or tangential points.
        """
    
    func processTranscription() async {
        
        let messages: [AbstractLLM.ChatMessage] = [
            .system(systemPrompt),
            .user (transcription.text)
        ]
        
        do {
            let completion = try await client.complete(
                messages,
                model: AIClientManager.chatModel
            )
            print(completion)
        } catch {
            print(error)
        }
        
        
    }
}
