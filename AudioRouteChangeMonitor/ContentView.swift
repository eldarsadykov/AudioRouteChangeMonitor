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
    var body: some View {
        NavigationStack {
            RouteChangeTable(routeChanges: $audioRouteManager.routeChanges)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Export") {
                            shareJSON()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear") {
                            audioRouteManager.routeChanges = []
                        }
                    }
                }
                .navigationTitle("Audio Route Changes")
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
