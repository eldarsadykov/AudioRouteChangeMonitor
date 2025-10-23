//
//  PlaybackTestView.swift
//  AudioRouteChangeMonitor
//
//  Created by Eldar Sadykov on 23.10.25.
//

import AVFoundation
import SwiftUI

struct PlaybackTestView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var audioRecorder: AVAudioRecorder?
    @State private var isLoaded = false
    @State private var isPlaying = false
    @State private var isRecording = false

    private var currentRecordingURL: URL? {
        let url = recordingURL()
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Simple Audio Player")
                .font(.headline)

            Button("Load Audio") {
                loadAudio()
            }
            .disabled(isLoaded)

            Button(action: togglePlayback) {
                Label(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.circle" : "play.circle")
                    .font(.largeTitle)
            }
            .disabled(!isLoaded)

            if isRecording {
                Label("Recording…", systemImage: "mic.fill")
                    .foregroundStyle(.red)
            }

            if let url = currentRecordingURL {
                ShareLink(item: url) {
                    Label("Share Recording", systemImage: "square.and.arrow.up")
                }
            } else {
                Button {
                } label: {
                    Label("Share Recording", systemImage: "square.and.arrow.up")
                }
                .disabled(true)
            }
        }
        .padding()
        .onDisappear {
            if isPlaying { audioPlayer?.stop() }
            if isRecording { stopRecording() }
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch {
                print("Failed to deactivate audio session: \(error)")
            }
        }
    }

    func loadAudio() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }

        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if !granted {
                    print("Microphone permission not granted.")
                }
            }
        }

        if let sound = Bundle.main.url(forResource: "sound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: sound)
                audioPlayer?.prepareToPlay()
                isLoaded = true
                print("Audio loaded successfully.")
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found in bundle.")
        }
    }

    private func recordingURL() -> URL {
        let tmp = FileManager.default.temporaryDirectory
        return tmp.appendingPathComponent("micRecording.m4a")
    }

    private func startRecording() {
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            let url = recordingURL()
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.prepareToRecord()
            let started = audioRecorder?.record() ?? false
            isRecording = started
            if started {
                print("Recording started at: \(url)")
            } else {
                print("Failed to start recording")
            }
        } catch {
            print("Error starting recording: \(error)")
            isRecording = false
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        let url = recordingURL()
        if FileManager.default.fileExists(atPath: url.path) {
            print("Recording available at: \(url)")
        }
    }

    func togglePlayback() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopRecording()
        } else {
            player.play()
            isPlaying = true
            startRecording()
        }
    }
}

#Preview {
    PlaybackTestView()
}
