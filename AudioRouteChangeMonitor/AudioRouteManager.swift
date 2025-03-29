//
//  AudioRouteManager.swift
//  AudioRouteChangeLogger
//
//  Created by Eldar Sadykov on 30.08.24.
//

import AVFoundation
import Foundation
import MediaPlayer

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

class AudioRouteManager: ObservableObject {
    @Published var routeChanges = Array<AudioRouteChange>()
    @Published var audioInputs: [String] = []
    let audioSession = AVAudioSession.sharedInstance()

    init() {
        setCategory()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruptionNotification), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMediaServicesWereLostNotification), name: AVAudioSession.mediaServicesWereLostNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMediaServicesWereResetNotification), name: AVAudioSession.mediaServicesWereResetNotification, object: nil)
        if #available(iOS 17.2, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(handleRenderingCapabilitiesChangeNotification), name: AVAudioSession.renderingCapabilitiesChangeNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleRenderingModeChangeNotification), name: AVAudioSession.renderingModeChangeNotification, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleSilenceSecondaryAudioHintNotification), name: AVAudioSession.silenceSecondaryAudioHintNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSpatialPlaybackCapabilitiesChangedNotification), name: AVAudioSession.spatialPlaybackCapabilitiesChangedNotification, object: nil)

        refreshAudioInputs()
    }

    func reportCategory() {
        print(audioSession.category)
        print(audioSession.categoryOptions)
    }

    @objc func handleInterruptionNotification(notification: Notification) {
        print("handleInterruptionNotification")
        print(notification.userInfo?.description ?? "No user info")
    }

    @objc func handleMediaServicesWereLostNotification(notification: Notification) {
        print("handleMediaServicesWereLostNotification")
        print(notification.userInfo?.description ?? "No user info")
    }

    @objc func handleMediaServicesWereResetNotification(notification: Notification) {
        print("handleMediaServicesWereResetNotification")
        print(notification.userInfo?.description ?? "No user info")
    }

    @objc func handleRenderingCapabilitiesChangeNotification(notification: Notification) {
        print("handleRenderingCapabilitiesChangeNotification")
        print(notification.userInfo?.description ?? "No user info")
    }

    @objc func handleRenderingModeChangeNotification(notification: Notification) {
        print("handleRenderingModeChangeNotification")
        print(notification.userInfo?.description ?? "No user info")
    }

    @objc func handleSilenceSecondaryAudioHintNotification(notification: Notification) {
        print("handleSilenceSecondaryAudioHintNotification")
        print(notification.userInfo?.description ?? "No user info")
    }

    @objc func handleSpatialPlaybackCapabilitiesChangedNotification(notification: Notification) {
        print("handleSpatialPlaybackCapabilitiesChangedNotification")
        print(notification.userInfo?.description ?? "No user info")
    }

    func refreshAudioInputs() {
        audioInputs = audioSession.availableInputs!.map({ portDescription in
            portDescription.portName
        })
    }

    func setCategory() {
        do {
            try audioSession.setCategory(
                .playAndRecord,
                options: [
                    .mixWithOthers,
                    .defaultToSpeaker,
                    .allowBluetooth,
                    .allowAirPlay,
                    .allowBluetoothA2DP,
                ]
            )
            try audioSession.setActive(true)
        } catch {
            fatalError("Failed to configure and activate session.")
        }
    }

    @objc func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue),
              let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
        else {
            return
        }

        let currentRoute = audioSession.currentRoute

        let routeChange = AudioRouteChange(reason, previousRoute, currentRoute)
        routeChanges.append(routeChange)
        refreshAudioInputs()
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
