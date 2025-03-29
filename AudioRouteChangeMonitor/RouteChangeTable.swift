//
//  RouteChangeTable.swift
//  KeyScroll
//
//  Created by Eldar Sadykov on 03.09.24.
//

import SwiftUI

struct RouteChangeTable: View {
    @Binding var routeChanges: [AudioRouteChange]
    @Binding var selection: AudioRouteChange.ID?
    var body: some View {
        Table(routeChanges, selection: $selection) {
            TableColumn("Reason") { routeChange in
                VStack(alignment: .leading) {
                    Text(routeChange.reasonDescription)
                        .font(.body)
                    Text(routeChange.createdAt.description)
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
            TableColumn("Previous Input") { routeChange in
                PortColumn(routeChange.previousRoute.inputs.first)
            }
            TableColumn("Previous Output") { routeChange in
                PortColumn(routeChange.previousRoute.outputs.first)
            }
            TableColumn("Current Input") { routeChange in
                PortColumn(routeChange.currentRoute.inputs.first)
            }
            TableColumn("Current Output") { routeChange in
                PortColumn(routeChange.currentRoute.outputs.first)
            }
        }
    }
}

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
