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
    @StateObject var audioRouteManager = RouteManager()
    @State private var path = [RouteChange]()
    @State private var selection: RouteChange.ID?
    @State private var isShowingClearWarning = false
    var body: some View {
        NavigationStack(path: $path) {
            RouteChangeTableView(routeChanges: $audioRouteManager.routeChanges, selection: $selection)
                .toolbar {
                    MainToolbarContent(isShowingClearWarning: $isShowingClearWarning,
                                       routeChanges: $audioRouteManager.routeChanges)
                }
                .navigationTitle("Audio Route Changes")
                .navigationDestination(for: RouteChange.self) { routeChange in
                    RouteChangeDetailView(routeChange: routeChange)
                        .onDisappear {
                            selection = nil
                        }
                }
                .onChange(of: selection, perform: onSelectionChange)
        }
    }
    
    func onSelectionChange(_ newValue: RouteChange.ID?) {
        if let newValue,
           let audioRouteChange = (audioRouteManager.routeChanges.first { routeChange in
               routeChange.id == newValue
           }) {
            path.append(audioRouteChange)
        }
    }
}

#Preview {
    ContentView()
}
