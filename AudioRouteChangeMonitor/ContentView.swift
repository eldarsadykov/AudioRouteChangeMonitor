//
//  AudioRouteTestView.swift
//  KeyScrollSynth
//
//  Created by Eldar Sadykov on 30.08.24.
//

import AVFoundation
import AVKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Route Changes", systemImage: "audio.jack.mono") {
                RouteChangesView()
            }
            Tab("Playback Test", systemImage: "waveform") {
                PlaybackTestView()
            }
        }
    }
}

#Preview {
    ContentView()
}
