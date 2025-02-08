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
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Clear") {
                            isShowingClearWarning = true
                        }
                        .alert("Clear all route changes?", isPresented: $isShowingClearWarning) {
                            Button(role: .destructive) {
                                audioRouteManager.routeChanges = []
                            } label: {
                                Text("Clear all")
                            }
                        }
                    }
                    if let jsonData = try? JSONEncoder().encode(audioRouteManager.routeChanges) {
                        let prettyJsonData = try? JSONSerialization.data(withJSONObject: try JSONSerialization.jsonObject(with: jsonData), options: .prettyPrinted)
                        if let prettyString = prettyJsonData.flatMap({ String(data: $0, encoding: .utf8) }) {
                            ToolbarItem(placement: .topBarTrailing) {
                                ShareLink(item: prettyString)
                            }
                        }
                    }
                }
                .navigationTitle("Audio Route Changes")
                .navigationDestination(for: AudioRouteChange.self) { routeChange in
                    AudioRouteChangeView(routeChange: routeChange)
                        .onDisappear {
                            selection = nil
                        }
                }
                .onChange(of: selection) { _, newValue in
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
