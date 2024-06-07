//
//  RecordingWaveView.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/17/24.
//

import SwiftUI
import DSWaveformImageViews
import DSWaveformImage
import Media

struct RecordingWaveView: View {
    
    @StateObject var viewModel: RecordingWaveViewModel
    
    private let configuration = Waveform.Configuration(style:
            .striped(.init(color: .red,
                           width: 3,
                           spacing: 3)),
                     verticalScalingFactor: 0.9)
    
    init(recorder: AudioRecorder) {
        _viewModel = StateObject(wrappedValue: RecordingWaveViewModel(recorder: recorder))
    }
    
    var body: some View {
        WaveformLiveCanvas(
            samples: viewModel.samples,
            configuration: configuration,
            renderer: LinearWaveformRenderer(),
            shouldDrawSilencePadding: true
        )
        .maxWidth(.infinity)
        .maxHeight(30)
    }
}
