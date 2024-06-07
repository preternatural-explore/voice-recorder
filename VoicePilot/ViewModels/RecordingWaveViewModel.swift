//
//  RecordingWaveViewModel.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/17/24.
//

import SwiftUI
import DSWaveformImage
import Media
import Combine

class RecordingWaveViewModel: ObservableObject {
    
    private let recorder: AudioRecorder
    
    private var cancellables = Set<AnyCancellable>()
    
    private var timer: Timer?
    
    @Published var samples: [Float] = []
    
    init(recorder: AudioRecorder) {
        self.recorder = recorder
        observeRecorderState()
    }
    
    private func observeRecorderState() {
        recorder.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] newState in
                self?.handleStateChange(newState)
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ newState: AudioRecorder.State) {
        switch newState {
        case .recording:
            startTimer()
        default:
            stopTimer()
        }
    }
    
    private func startTimer() {
        // Start or reset the timer to update the samples
        timer?.invalidate() // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let power = 1 - self.recorder.normalizedPowerLevel
            // add three times to show the wave as faster
            self.samples.append(contentsOf: [power,power,power])
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        samples = []
    }
}
