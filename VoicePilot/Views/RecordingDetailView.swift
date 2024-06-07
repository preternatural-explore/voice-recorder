//
//  RecordingDetailView.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/26/24.
//

import SwiftUI

struct RecordingDetailView: View {
    
    @State var recording: Recording
    
    var body: some View {
        recordingInfoView
    }
    
    @ViewBuilder
    private var recordingInfoView: some View {
        ScrollView {
            VStack (alignment: .leading) {
                if recording.isTranscribed == false || recording.isAnalyzed == false {
                    Text("Processing...")
                        .italic()
                }
                Text(recording.title)
                    .font(.title)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .center)
                //            Text(viewModel.formattedDate)
                //                .italic()
                if let summary = recording.summary {
                    VStack(alignment: .leading) {
                        Text("SUMMARY:")
                            .font(.subheadline)
                        Text("\(summary)")
                            .font(.title3)
                            .lineLimit(nil)
                    }
                    .padding()
                } else {
                    ProgressView()
                }
                
                if let keyPoints = recording.keyPoints {
                    VStack(alignment: .leading) {
                        Text("KEY POINTS:")
                            .font(.subheadline)
                        ForEach(keyPoints, id: \.self) { keyPoint in
                            Text("* \(keyPoint.text)")
                        }
                    }.padding()
                }
                
                if let transcription = recording.transcription {
                    VStack(alignment: .leading) {
                        Text("TRANSCRIPTION:")
                            .font(.subheadline)
                        Text("\(transcription)")
                    }.padding()
                }
                
                if let segments = recording.orderedSegments {
                    VStack(alignment: .leading) {
                        Text("SEGMENTS:")
                            .font(.subheadline)
                        ForEach(segments, id: \.self) { segment in
                            Text("\(segment.formattedTimestampText): \(segment.text)")
                        }
                        .padding(.bottom, 1)
                    }.padding()
                }
            }
        }
    }

}
