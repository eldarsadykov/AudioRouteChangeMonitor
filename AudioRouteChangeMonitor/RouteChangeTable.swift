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
                VStack {
                    Text(routeChange.reason.description)
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
