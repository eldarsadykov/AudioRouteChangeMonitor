//
//  RouteChangeTableToolbar.swift
//  AudioRouteChangeMonitor
//
//  Created by Eldar Sadykov on 29.03.25.
//

import SwiftUI

struct MainToolbarContent: ToolbarContent {
    @Binding var isShowingClearWarning: Bool
    @Binding var routeChanges: [RouteChange]

    @Environment(\.openURL) private var openURL

    var prettyString: String? {
        guard let jsonData = try? JSONEncoder().encode(routeChanges) else { return nil }
        let prettyJsonData = try? JSONSerialization.data(withJSONObject: try JSONSerialization.jsonObject(with: jsonData), options: .prettyPrinted)
        return prettyJsonData.flatMap({ String(data: $0, encoding: .utf8) })
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Clear") {
                isShowingClearWarning = true
            }
            .alert("Clear all route changes?", isPresented: $isShowingClearWarning) {
                Button(role: .destructive) {
                    routeChanges = []
                } label: {
                    Text("Clear all")
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                if let url = URL(string: "https://github.com/eldarsadykov/AudioRouteChangeMonitor") {
                    openURL(url)
                }
            } label: {
                Label("GitHub", image: "github.fill")
            }
        }
        if let prettyString {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: prettyString)
            }
        }
    }
}
