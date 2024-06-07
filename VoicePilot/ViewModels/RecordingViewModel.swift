//
//  RecordedObjectViewModel.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/18/24.
//

import SwiftUI
import Media

class RecordingViewModel: ObservableObject {
    
    @Bindable var recording: Recording
    private let audioPlayer = AudioPlayer()
    @Published private(set) var isPlaying = false
    
    init(recording: Recording) {
        self.recording = recording
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: recording.createdDate)
    }
    

    @MainActor
    func playAudio() async {
        isPlaying = true
        do {
            try await audioPlayer.play(recording.audioData, fileTypeHint: nil)
            isPlaying = false
        } catch {
            isPlaying = false
            print(error)
        }
        
    }
    
    @MainActor
    func stopAudio() async {
        audioPlayer.stop()
        isPlaying = false
    }
}
