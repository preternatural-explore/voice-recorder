//
//  OAITranscriptionCreationManager.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/26/24.
//

import OpenAI
import Foundation
import Media
import NaturalLanguage

struct TranscriptionCreationManager {
        
    private let client = AIClientManager.client
    
    let recording: Recording
    let recordingDatabase: RecordingDatabase
    
    
    func getTranscription() async {
        if let url = recording.urlToTranscribe {
            do {
                
                let file: URL = try await MediaAssetLocation.url(url).convert(to: .wav)
                
                 //Read about prompts here: https://platform.openai.com/docs/guides/speech-to-text/prompting?lang=python
                
                let transcription = try await client.createTranscription(
                    audioFile: file,
                    prompt: nil,
                    timestampGranularities: [.segment],
                    responseFormat: .verboseJSON
                )
                
//                let transcriptionProcessor = TranscriptionProcessessingManager(transcription: transcription, recording: recording, recordingDatabase: recordingDatabase)
//                await transcriptionProcessor.processTranscription()
                
                await recordingDatabase.processTranscription(transcription, forRecording: recording)
                
            } catch {
                print(error)
            }
        }
    }
}

