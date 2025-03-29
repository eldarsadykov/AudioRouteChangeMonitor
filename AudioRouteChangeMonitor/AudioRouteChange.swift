//
//  RouteChange.swift
//  AudioRouteChangeMonitor
//
//  Created by Eldar Sadykov on 29.03.25.
//

import AVFoundation

struct AudioRouteChange: Identifiable, Encodable, Hashable {
    let createdAt = Date()
    let id = UUID()
    var reason: AVAudioSession.RouteChangeReason
    var previousRoute: AVAudioSessionRouteDescription
    var currentRoute: AVAudioSessionRouteDescription

    init(_ reason: AVAudioSession.RouteChangeReason, _ previousRoute: AVAudioSessionRouteDescription, _ currentRoute: AVAudioSessionRouteDescription) {
        self.reason = reason
        self.previousRoute = previousRoute
        self.currentRoute = currentRoute
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(reason.description, forKey: .reason)
        try container.encode(RouteDescription(from: previousRoute), forKey: .previousRoute)
        try container.encode(RouteDescription(from: currentRoute), forKey: .currentRoute)
    }

    enum CodingKeys: String, CodingKey {
        case createdAt, reason, previousRoute, currentRoute
    }
}

extension AudioRouteChange: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        let reasonsMatch = lhs.reason == rhs.reason
        let previousRouteInputsMatch = lhs.previousRoute.inputs.first?.uid == rhs.previousRoute.inputs.first?.uid
        let previousRouteOutputsMatch = lhs.previousRoute.outputs.first?.uid == rhs.previousRoute.outputs.first?.uid
        let currentRouteInputsMatch = lhs.currentRoute.inputs.first?.uid == rhs.currentRoute.inputs.first?.uid
        let currentRouteOutputsMatch = lhs.currentRoute.outputs.first?.uid == rhs.currentRoute.outputs.first?.uid
        return
            reasonsMatch &&
            previousRouteInputsMatch &&
            previousRouteOutputsMatch &&
            currentRouteInputsMatch &&
            currentRouteOutputsMatch
    }
}

struct RouteDescription: Encodable {
    var inputs: [PortDescription]
    var outputs: [PortDescription]

    init(from route: AVAudioSessionRouteDescription) {
        inputs = route.inputs.map { PortDescription(from: $0) }
        outputs = route.outputs.map { PortDescription(from: $0) }
    }
}

struct PortDescription: Encodable {
    var portName: String
    var portType: String
    var uid: String

    init(from port: AVAudioSessionPortDescription) {
        portName = port.portName
        portType = port.portType.rawValue
        uid = port.uid
    }
}
