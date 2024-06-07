//
//  VoiceAITestApp.swift
//  VoiceAITest
//
//  Created by Natasha Murashev on 4/15/24.
//

import SwiftUI

@main
struct VoicePilotApp: App {
    
    let recordingDatabase: RecordingDatabase = {
        do {
            let db = try RecordingDatabase()
            
            return db
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            RecordingListView(recordingDatabase: recordingDatabase)
        }
    }
}
