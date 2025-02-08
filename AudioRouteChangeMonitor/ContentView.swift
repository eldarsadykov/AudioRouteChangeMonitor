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
    var body: some View {
        NavigationStack(path: $path) {
            RouteChangeTable(routeChanges: $audioRouteManager.routeChanges, selection: $selection)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Clear") {
                            audioRouteManager.routeChanges = []
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            shareJSON()
                        } label: {
                            Text("Export")
                        }
                    }
                }
                .navigationTitle("Audio Route Changes")
                .navigationDestination(for: AudioRouteChange.self) { routeChange in
                    AudioRouteChangeView(routeChange: routeChange)
                        .onDisappear() {
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

    func getAvailableCaptureDevices() -> [AVCaptureDevice] {
        // Specify the device types you want to discover
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.microphone, .external]

        // Specify the media type (audio or video)
        let mediaType = AVMediaType.audio

        // Create a discovery session for the specified devices
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: mediaType,
            position: .unspecified
        )

        // Return the discovered devices
        return discoverySession.devices
    }

    func shareJSON() {
        guard let jsonData = try? JSONEncoder().encode(audioRouteManager.routeChanges),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to encode JSON")
            return
        }

        let activityVC = UIActivityViewController(activityItems: [jsonString], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}

#Preview {
    ContentView()
}
