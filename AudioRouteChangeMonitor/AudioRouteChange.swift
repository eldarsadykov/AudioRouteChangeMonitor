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
    var reasonDescription: String
    var previousRoute: RouteDescription
    var currentRoute: RouteDescription

    init(_ reasonDescription: String, _ previousRoute: RouteDescription, _ currentRoute: RouteDescription) {
        self.reasonDescription = reasonDescription
        self.previousRoute = previousRoute
        self.currentRoute = currentRoute
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(reasonDescription, forKey: .reason)
        try container.encode(previousRoute, forKey: .previousRoute)
        try container.encode(currentRoute, forKey: .currentRoute)
    }

    enum CodingKeys: String, CodingKey {
        case createdAt, reason, previousRoute, currentRoute
    }
}

extension AudioRouteChange: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        let reasonsDescriptionsMatch = lhs.reasonDescription == rhs.reasonDescription
        let previousRouteInputsMatch = lhs.previousRoute.inputs.first?.uid == rhs.previousRoute.inputs.first?.uid
        let previousRouteOutputsMatch = lhs.previousRoute.outputs.first?.uid == rhs.previousRoute.outputs.first?.uid
        let currentRouteInputsMatch = lhs.currentRoute.inputs.first?.uid == rhs.currentRoute.inputs.first?.uid
        let currentRouteOutputsMatch = lhs.currentRoute.outputs.first?.uid == rhs.currentRoute.outputs.first?.uid
        return
            reasonsDescriptionsMatch &&
            previousRouteInputsMatch &&
            previousRouteOutputsMatch &&
            currentRouteInputsMatch &&
            currentRouteOutputsMatch
    }
}

struct RouteDescription: Encodable, Equatable, Hashable {
    var inputs: [PortDescription]
    var outputs: [PortDescription]

    init(from route: AVAudioSessionRouteDescription) {
        inputs = route.inputs.map { PortDescription(from: $0) }
        outputs = route.outputs.map { PortDescription(from: $0) }
    }
}

struct PortDescription: Encodable, Equatable, Hashable {
    var portName: String
    var portType: String
    var uid: String

    init(from port: AVAudioSessionPortDescription) {
        portName = port.portName
        portType = port.portType.rawValue
        uid = port.uid
    }
}

extension AVAudioSession.RouteChangeReason {
    public var description: String {
        switch self {
        case .unknown:
            return "0 - Unknown"
        case .newDeviceAvailable:
            return "1 - New Device Available"
        case .oldDeviceUnavailable:
            return "2 - Old Device Unavailable"
        case .categoryChange:
            return "3 - Category Change"
        case .override:
            return "4 - Override"
        case .wakeFromSleep:
            return "6 - Wake From Sleep"
        case .noSuitableRouteForCategory:
            return "7 - No Suitable Route For Category"
        case .routeConfigurationChange:
            return "8 - Route Configuration Change"
        @unknown default:
            fatalError()
        }
    }
}
