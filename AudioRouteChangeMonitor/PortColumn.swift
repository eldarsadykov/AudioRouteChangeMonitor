//
//  PortColumn.swift
//  KeyScroll
//
//  Created by Eldar Sadykov on 03.09.24.
//

import AVFAudio
import SwiftUI

struct PortColumn: View {
    var port: PortDescription?

    init(_ port: PortDescription? = nil) {
        self.port = port
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(port?.portName ?? "N/A")
                .font(.body)
            Text("Type: " + (port?.portType ?? "N/A"))
            Text("UID: " + (port?.uid ?? "N/A"))
        }
        .font(.caption)
    }
}

#Preview {
    PortColumn()
}
