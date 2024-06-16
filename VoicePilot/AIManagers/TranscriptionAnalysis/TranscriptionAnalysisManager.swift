//
//  TranscriptionParsingManager.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/25/24.
//

import OpenAI

struct TranscriptionAnalysisManager {

    static let client = AIClientManager.client
    
    static func getAnalysisForRecording(_ recording: Recording, recordingDatabase: RecordingDatabase) async {
        let promptManager = TranscriptionAnalysisPromptManager()
        let sampleRecordingObject = promptManager.sampleRecordingObject
        
        if let transcription = recording.transcription {
            let messages: [AbstractLLM.ChatMessage] = [
                .system(promptManager.systemPrompt),
                .user(sampleRecordingObject.recordingText),
                .functionCall(
                    of: promptManager.addRecordingAnalysisFunction,
                    arguments: sampleRecordingObject.expectedResult),
                .user(transcription)
            ]
            do {
                
                let functionCall: AbstractLLM.ChatFunctionCall = try await client.complete(
                    messages,
                    functions: [promptManager.addRecordingAnalysisFunction],
                    as: .functionCall
                )
                
                let recordingAnalysis = try functionCall.decode(TranscriptionAnalysisPromptManager.AddRecordingResult.self).recordingAnalysis
                
                await recordingDatabase.processRecordingAnalysis(recordingAnalysis, forRecording: recording)
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
