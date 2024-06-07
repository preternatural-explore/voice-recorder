//
//  RecordingObjectView.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/18/24.
//

import SwiftUI

struct RecordingView: View {
    
    @State var recording: Recording
    private let recordingDatabase: RecordingDatabase
    
    @StateObject private var viewModel: RecordingViewModel
    
    init(recording: Recording, recordingDatabase: RecordingDatabase) {
        _recording = State(wrappedValue: recording)
        _viewModel = StateObject(wrappedValue: RecordingViewModel(recording: recording))
        self.recordingDatabase = recordingDatabase
    }
    
    var body: some View {
        recordingInfoView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
#if os(iOS)
            .swipeActions {
                deleteButton(forRecording: recording)
            }
#else
            .contextMenu {
                deleteButton(forRecording: recording)
            }
#endif
    }
    
    @ViewBuilder
    private var recordingInfoView: some View {
        VStack (alignment: .leading) {
            if recording.isTranscribed == false || recording.isAnalyzed == false {
                Text("Processing...")
                    .italic()
            }
            HStack(alignment: .firstTextBaseline) {
                Text(recording.title)
                    .font(.title2)
                    .lineLimit(nil)
                Spacer()
                toggleAudioButton
                    .buttonStyle(.plain)
            }
            Text(viewModel.formattedDate)
                .italic()
            if let summary = recording.summary {
                Text(summary)
                    .font(.title3)
                    .lineLimit(nil)
            }
        }
    }
    
    @ViewBuilder
    private var toggleAudioButton: some View {
        if viewModel.isPlaying {
            stopButton
        } else {
            playButton
        }
    }
    
    
    @ViewBuilder
    private var playButton: some View {
        Button(action: {
            Task { @MainActor in
                await viewModel.playAudio()
            }
        }) {
            Image(systemName: "speaker.3.fill")
                .font(.title2)
                .frame(width: 44, height: 44, alignment: .center)
                .foregroundColor(.blue)
            
        }
    }
    
    @ViewBuilder
    private var stopButton: some View {
        Button(action: {
            Task { @MainActor in
                await viewModel.stopAudio()
            }
        }) {
            Image(systemName: "stop.fill")
                .font(.title2)
                .foregroundColor(.red)
                .frame(width: 44, height: 44, alignment: .center)
        }
    }
    
    @ViewBuilder
    private func deleteButton(forRecording recording: Recording) -> some View {
        Button("Delete", systemImage: "trash", role: .destructive) {
            Task { @MainActor in
                try await recordingDatabase.delete(recording)
            }
        }
    }
}
