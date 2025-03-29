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
    @StateObject var audioRouteManager = AudioRouteManager()
    @State private var path = [AudioRouteChange]()
    @State private var selection: AudioRouteChange.ID?
    @State private var isShowingClearWarning = false
    var body: some View {
        NavigationStack(path: $path) {
            RouteChangeTable(routeChanges: $audioRouteManager.routeChanges, selection: $selection)
                .toolbar {
                    RouteChangeTableToolbar(isShowingClearWarning: $isShowingClearWarning,
                                            routeChanges: $audioRouteManager.routeChanges)
                }
                .navigationTitle("Audio Route Changes")
                .navigationDestination(for: AudioRouteChange.self) { routeChange in
                    AudioRouteChangeView(routeChange: routeChange)
                        .onDisappear {
                            selection = nil
                        }
                }
                .onChange(of: selection) { newValue in
                    if let newValue,
                       let audioRouteChange = (audioRouteManager.routeChanges.first { routeChange in
                           routeChange.id == newValue
                       }) {
                        path.append(audioRouteChange)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
