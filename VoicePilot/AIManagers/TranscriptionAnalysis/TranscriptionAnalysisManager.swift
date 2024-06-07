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
                .user {
                    .concatenate(separator: nil) {
                        sampleRecordingObject.recordingText
                    }
                },
                .functionCall(
                    of: promptManager.addRecordingAnalysisFunction,
                    arguments: sampleRecordingObject.expectedResult),
                .user {
                    .concatenate(separator: nil) {
                        PromptLiteral(transcription)
                    }
                }
            ]
            do {
                let completion = try await client.complete(
                    messages,
                    parameters: AbstractLLM.ChatCompletionParameters(
                        tools: [promptManager.addRecordingAnalysisFunction]
                    ),
                    model: AIClientManager.chatModel
                )
                                
                if let recordingAnalysis = try completion._allFunctionCalls.first?.decode(TranscriptionAnalysisPromptManager.AddRecordingResult.self).recordingAnalysis {
                    
                    await recordingDatabase.processRecordingAnalysis(recordingAnalysis, forRecording: recording)
                } else {
                    let assistantReply = completion.message.content
                    await recordingDatabase.processRecordingAnalysiFailure(assistantReply, forRecording: recording)
                }
                    
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
