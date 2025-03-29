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

    var previousInput: PortDescription? { routeChange.previousRoute.inputs.first }
    var previousOutput: PortDescription? { routeChange.previousRoute.outputs.first }
    var currentInput: PortDescription? { routeChange.currentRoute.inputs.first }
    var currentOutput: PortDescription? { routeChange.currentRoute.outputs.first }

    var body: some View {
        Form {
            Section("Created At") {
                Text(routeChange.createdAt.description)
            }
            Section("Reason") {
                Text(routeChange.reasonDescription)
            }
            AudioRouteChangePortView(label: "Previous Input", port: previousInput)
            AudioRouteChangePortView(label: "Previous Output", port: previousOutput)
            AudioRouteChangePortView(label: "Current Input", port: currentInput)
            AudioRouteChangePortView(label: "Current Output", port: currentOutput)
        }
    }
}

struct AudioRouteChangePortView: View {
    let label: String
    let port: PortDescription?
    var body: some View {
        Section(label) {
            Text("Name: \(port?.portName ?? "N/A")")
            Text("Port Type: \(port?.portType ?? "N/A")")
            Text("UID: \(port?.uid ?? "N/A")")
        }
    }
}
