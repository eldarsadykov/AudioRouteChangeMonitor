//
//  PortColumn.swift
//  KeyScroll
//
//  Created by Eldar Sadykov on 03.09.24.
//

import AVFAudio
import SwiftUI

struct PortColumn: View {
    var port: AVAudioSessionPortDescription?

    init(_ port: AVAudioSessionPortDescription? = nil) {
        self.port = port
    }

    var body: some View {
        if let port {
            VStack(alignment: .leading) {
                Text(port.portName)
                    .font(.body)
                Text("Type: " + port.portType.rawValue)
                Text("UID: " + port.uid)
            }
            .font(.caption)
        } else {
            Text("No port")
        }
    }
}

#Preview {
    PortColumn()
}
