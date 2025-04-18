//
//  RouteChange.swift
//  AudioRouteChangeMonitor
//
//  Created by Eldar Sadykov on 29.03.25.
//

import AVFoundation
import SwiftUI

struct RouteChange: Identifiable, Codable, Hashable {
    let id = UUID()
    var createdAt = Date()
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        reasonDescription = try container.decode(String.self, forKey: .reason)
        previousRoute = try container.decode(RouteDescription.self, forKey: .previousRoute)
        currentRoute = try container.decode(RouteDescription.self, forKey: .currentRoute)
    }

    enum CodingKeys: String, CodingKey {
        case createdAt, reason, previousRoute, currentRoute
    }
}

struct RouteDescription: Codable, Equatable, Hashable {
    var inputs: [PortDescription]
    var outputs: [PortDescription]

    init(from route: AVAudioSessionRouteDescription) {
        inputs = route.inputs.map { PortDescription(from: $0) }
        outputs = route.outputs.map { PortDescription(from: $0) }
    }
}

struct PortDescription: Codable, Equatable, Hashable {
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

struct RouteChanges: Codable {
    var routeChanges: [RouteChange]
    init(_ routeChanges: [RouteChange]) {
        self.routeChanges = routeChanges
    }
}

extension RouteChanges: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .json)
            .suggestedFileName("routeChanges.json")
    }
}
