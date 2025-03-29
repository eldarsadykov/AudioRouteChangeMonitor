//
//  AudioRouteManager.swift
//  AudioRouteChangeLogger
//
//  Created by Eldar Sadykov on 30.08.24.
//

import AVFoundation

class RouteManager: ObservableObject {
    @Published var routeChanges: [RouteChange] = []

    let audioSession = AVAudioSession.sharedInstance()

    init() {
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

        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
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

        let routeChange = RouteChange(
            reason.description,
            RouteDescription(from: previousRoute),
            RouteDescription(from: currentRoute)
        )
        routeChanges.append(routeChange)
    }
}
