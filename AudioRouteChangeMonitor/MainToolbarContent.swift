//
//  RouteChangeTableToolbar.swift
//  AudioRouteChangeMonitor
//
//  Created by Eldar Sadykov on 29.03.25.
//

import SwiftUI

struct MainToolbarContent: ToolbarContent {
    @Binding var isShowingClearWarning: Bool
    @ObservedObject var routeChangesManager: RouteChangesManager
    @State private var isShowingImporter: Bool = false
    @State private var isShowingImporterError: Bool = false
    @State private var importerErrorDescription: String?
    @Environment(\.openURL) private var openURL

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Clear") {
                isShowingClearWarning = true
            }
            .alert("Clear all route changes?", isPresented: $isShowingClearWarning) {
                Button(role: .destructive) {
                    routeChangesManager.routeChanges = []
                } label: {
                    Text("Clear all")
                }
            }
        }

        ToolbarItem(placement: .automatic) {
            Button {
                if let url = URL(string: "https://github.com/eldarsadykov/AudioRouteChangeMonitor") {
                    openURL(url)
                }
            } label: {
                Label("GitHub", image: "github.fill")
            }
        }
        if #available(iOS 26.0, *) {
            ToolbarSpacer(.fixed)
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                isShowingImporter.toggle()
            } label: {
                Label("Import JSON", systemImage: "square.and.arrow.down")
            }
            .fileImporter(isPresented: $isShowingImporter, allowedContentTypes: [.json], allowsMultipleSelection: false, onCompletion: { results in
                switch results {
                case let .failure(error):
                    print("Error selecting file \(error.localizedDescription)")

                case let .success(fileURLs):
                    let url = fileURLs[0]

                    do {
                        if url.startAccessingSecurityScopedResource() {
                            try routeChangesManager.importFromJSONFile(url)
                            url.stopAccessingSecurityScopedResource()
                        }
                    } catch {
                        importerErrorDescription = error.localizedDescription
                        isShowingImporterError = true
                    }
                }
            })
            .alert("Error importing JSON file", isPresented: $isShowingImporterError) {
            } message: {
                Text(importerErrorDescription ?? "No description.")
            }

            ShareLink(item: RouteChanges(routeChangesManager.routeChanges), preview: SharePreview("Audio Route Changes JSON"))
        }
    }
}
