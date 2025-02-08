//
//  RouteChangeTable.swift
//  KeyScroll
//
//  Created by Eldar Sadykov on 03.09.24.
//

import SwiftUI

struct RouteChangeTable: View {
    @Binding var routeChanges: [AudioRouteChange]
    var body: some View {
        Table(routeChanges) {
            TableColumn("Reason", value: \.reason.description)
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
