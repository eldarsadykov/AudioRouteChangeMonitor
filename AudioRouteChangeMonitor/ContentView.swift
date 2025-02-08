//
//  AudioRouteTestView.swift
//  KeyScrollSynth
//
//  Created by Eldar Sadykov on 30.08.24.
//

import AVFoundation
import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject var audioRouteManager = AudioRouteManager()
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Log")
                    Spacer()
                    Button("Category") {
                        audioRouteManager.reportCategory()
                    }
                    Spacer()
                    Button("Clear") {
                        audioRouteManager.routeChanges = []
                    }
                }
                .padding()
                RouteChangeTable(routeChanges: $audioRouteManager.routeChanges)
            }
            VStack {
                HStack {
                    Text("Inputs")
                    Spacer()
                    Button("Refresh") {
                        audioRouteManager.refreshAudioInputs()
                    }
                }
                .padding()
                List {
                    Section("AudioSession") {
                        ForEach(audioRouteManager.audioInputs, id: \.self) { audioInput in
                            Text(audioInput)
                        }
                    }
                }
            }
            .frame(maxWidth: 200)
        }
//        HStack {
//            VStack {
//                HStack {
//                    Text("Log")
//                    Spacer()
//                    Button("Clear") {
//                        audioRouteManager.routeChanges = []
//                    }
//                }
//                .padding()
//                List {
//                    Section("Messages") {
//                        ForEach(audioRouteManager.routeChanges) { routeChange in
//                            let reason = routeChange.reason
//                            Text("Reason \(reason.rawValue) – \(reason.description)")
//                        }
//                    }
//                }
//            }

//        }
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
}

#Preview {
    ContentView()
}
