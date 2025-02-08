//
//  AudioRouteChangeView.swift
//  AudioRouteChangeMonitor
//
//  Created by Eldar Sadykov on 08.02.25.
//

import AVFAudio
import SwiftUI

struct AudioRouteChangeView: View {
    let routeChange: AudioRouteChange

    var previousInput: AVAudioSessionPortDescription? { routeChange.previousRoute.inputs.first }
    var previousOutput: AVAudioSessionPortDescription? { routeChange.previousRoute.outputs.first }
    var currentInput: AVAudioSessionPortDescription? { routeChange.currentRoute.inputs.first }
    var currentOutput: AVAudioSessionPortDescription? { routeChange.currentRoute.outputs.first }
    
    var body: some View {
        Form {
            Text("Reason: \(routeChange.reason.description)")
            AudioRouteChangePortView(label: "Previous Input", port: previousInput)
            AudioRouteChangePortView(label: "Previous Output", port: previousOutput)
            AudioRouteChangePortView(label: "Current Input", port: currentInput)
            AudioRouteChangePortView(label: "Current Output", port: currentOutput)
        }
    }
}

struct AudioRouteChangePortView: View {
    let label: String
    let port: AVAudioSessionPortDescription?
    var body: some View {
        Section(label) {
            Text("Name: \(port?.portName ?? "N/A")")
            Text("Port Type: \(port?.portType.rawValue ?? "N/A")")
            Text("UID: \(port?.uid ?? "N/A")")
        }
    }
}
