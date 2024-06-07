//
//  ContentView.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/15/24.
//

import SwiftUI
import Media
import SwiftData

struct RecordingListView: View {
    
    @StateObject private var recordingDatabase: RecordingDatabase
    @StateObject private var viewModel: RecorderViewModel
    
    @State private var selectedRecording: Recording?
    
    
    init(recordingDatabase: RecordingDatabase) {
        _recordingDatabase = StateObject(wrappedValue: recordingDatabase)
        _viewModel = StateObject(wrappedValue: RecorderViewModel(recordingDatabase: recordingDatabase))
    }
    
    var body: some View {
        
        NavigationSplitView {
            recordingsList
        } detail: {
            if let selectedRecording = selectedRecording {
                RecordingDetailView(recording: selectedRecording)
                    .id(selectedRecording.id)
            }
        }
    }
    
    @ViewBuilder
    private var recordingsList: some View {
        List(recordingDatabase.recordings, selection: $selectedRecording) { recording in
            NavigationLink(value: recording) {
                RecordingView(recording: recording, recordingDatabase: recordingDatabase)
            }
        }
        .frame(minWidth: 250)
        .navigationTitle("AI Voice Recorder")
        .overlay {
            noRecordingsView
        }
        .safeAreaInset(edge: .bottom) {
            recordButtonOverlay
        }
        .onAppear {
            Task(priority: .userInitiated) {
                recordingDatabase.transcribeRecordings()
                recordingDatabase.analyzeRecordings()
            }
        }
    }
    
    @ViewBuilder
    private var recordButtonOverlay: some View {
        VStack {
            Divider()
            if viewModel.isRecording {
                RecordingWaveView(recorder: viewModel.recorder)
                    .padding(.top, .large)
            }
            
            RecordButtonView(viewModel: viewModel)
        }
        .background(Material.ultraThinMaterial)
    }
    
    @ViewBuilder
    private var noRecordingsView: some View {
        if recordingDatabase.recordings.count == 0 {
            VStack {
                Image(systemName: "mic")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Record to get started")
            }
            .offset(y: -100)
        }
    }
}
