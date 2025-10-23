//
//  RouteChanges.swift
//  AudioRouteChangeMonitor
//
//  Created by Eldar Sadykov on 23.10.25.
//

import SwiftUI

struct RouteChangesView: View {
    @StateObject var routeChangesManager = RouteChangesManager()
    @State private var path = [RouteChange]()
    @State private var selection: RouteChange.ID?
    @State private var isShowingClearWarning = false
    var body: some View {
        NavigationStack(path: $path) {
            RouteChangeTableView(routeChanges: $routeChangesManager.routeChanges, selection: $selection)
                .toolbar {
                    MainToolbarContent(isShowingClearWarning: $isShowingClearWarning,
                                       routeChangesManager: routeChangesManager)
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
           let audioRouteChange = (routeChangesManager.routeChanges.first { routeChange in
               routeChange.id == newValue
           }) {
            path.append(audioRouteChange)
        }
    }
}

#Preview {
    RouteChangesView()
}
