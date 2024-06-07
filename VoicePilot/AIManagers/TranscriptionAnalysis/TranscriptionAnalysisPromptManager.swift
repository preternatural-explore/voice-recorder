//
//  RecordingAnalysisPromptManager.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/25/24.
//

import OpenAI
import CorePersistence
import SwiftUIX

struct TranscriptionAnalysisPromptManager {
        
    var systemPrompt: String {
        """
        You are AudioTranscriptionProcessorGPT.
        
        The user will give you a transcribed text from an audio recording.
        Your job is to provide the following information about the recording:
        
        1. A short Title describing the recording
        2. A short one-sentence Summary about the recording
        3. A List of up to 5 most important points from the recording
        
        Use the `add_recording_analysis_to_db` function to the database.
        """
    }
    
    struct AddRecordingResult: Codable, Hashable, Sendable {
        struct RecordingAnalysis: Codable, Hashable, Sendable {
            var title: String
            var summary: String
            var keypoints: [String]
        }
        
        var recordingAnalysis: RecordingAnalysis
    }
    
    var addRecordingAnalysisFunction: AbstractLLM.ChatFunctionDefinition { AbstractLLM.ChatFunctionDefinition(
        name: "add_recording_analysis_to_db",
        context: "Add the title, summary, and five important points from this transcription of an audio recording.",
        parameters: JSONSchema(
            type: .object,
            description: "A Recording Analysis of the Audio Transcription",
            properties: [
                "recording_analysis": recordingTransliterationObjectSchema
            ]))
    }
    
    private var recordingTransliterationObjectSchema: JSONSchema { JSONSchema(
        type: .object,
        description: "The analysis of an audio transcription",
        properties: [
            "title" : JSONSchema(type: .string,
                                 description: "A short Title describing the recording"),
            "summary" : JSONSchema(type: .string,
                                   description: "A short one-sentence Summary about the recording"),
            "keypoints" : JSONSchema(type: .array,
                                      description: "A List of up to 5 most important points from the recording",
                                      items: .string)
        ],
        required: true
    )}
    
    struct PromptRecordingSampleObject {
        let recordingText: PromptLiteral
        let expectedResult: JSON
    }
    
    var sampleRecordingObject: PromptRecordingSampleObject {
        let exampleAudioTranscription = PromptLiteral("""
            Thank you. Suhasini. Good afternoon, everyone, and thanks for joining the call. Today, Apple is reporting revenue of $119.6 billion for the December quarter, up 2% from a year ago despite having one less week in the quarter. EPS was $2.18, up 16% from a year ago and an all-time record. We achieved revenue records across more than two dozen countries and regions including all-time records in Europe and rest of Asia-Pacific. We also continue to see strong double-digit growth in many emerging markets with all-time records in Malaysia, Mexico, The Philippines, Poland, and Turkey, as well as December quarter records in India, Indonesia, Saudi Arabia, and Chile. In Services, we set an all-time revenue record with paid subscriptions growing double-digits year-over-year.
            
               And I'm pleased to announce today that we have set a new record for our installed base, which has now surpassed 2.2 billion active devices. We are announcing these results on the eve of what is sure to be a historic day as we enter the era of spatial computing. Starting tomorrow, Apple Vision Pro, the most advanced personal electronics device ever, will be available in Apple stores for customers in the U.S. with expansion to other countries later this year. Apple Vision Pro is a revolutionary device built on decades of Apple innovation and it's years ahead of anything else. Apple Vision Pro has a groundbreaking new input system and thousands of innovations, and it will unlock incredible experiences for users and developers that are simply not possible on any other device.
            """)
        
        let expectedResult: JSON = ["recording_analysis" : .dictionary([
            "title" : "Apple's Record-breaking Revenue and Introduction of Apple Vision Pro",
            "summary" : "Apple reports record revenue for the December quarter, achieving all-time records in various countries and regions, and introduces the revolutionary Apple Vision Pro, set to unlock unique user experiences.",
            "keypoints" : .array([
                "Apple reported revenue of $119.6 billion for the December quarter, up 2% from the previous year, with EPS of $2.18, marking a 16% increase.",
                "Revenue records were achieved in over two dozen countries and regions, including all-time highs in Europe and rest of Asia-Pacific.",
                "Strong double-digit growth was seen in emerging markets, with all-time revenue records set in Malaysia, Mexico, The Philippines, Poland, and Turkey, and December quarter records in India, Indonesia, Saudi Arabia, and Chile.",
                "A new record was set for Apple's installed base, surpassing 2.2 billion active devices, along with an all-time revenue record in Services.",
                "Apple is introducing Apple Vision Pro, described as the most advanced personal electronics device, with unique features and capabilities aimed at providing unparalleled user experiences and opportunities for developers."])
        ])]
        
        return PromptRecordingSampleObject(
            recordingText: exampleAudioTranscription,
            expectedResult: expectedResult)
    }
}
