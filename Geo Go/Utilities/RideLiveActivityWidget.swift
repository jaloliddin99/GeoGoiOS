//
//  RideLiveActivityWidget.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/04/25.
//
import WidgetKit
import SwiftUI
import ActivityKit


struct RideLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RideAttributes.self) { context in
            // Lock screen live activity UI
            VStack {
                Text("Fare: \(context.state.price)")
                Text(context.state.statusIcon)
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.statusIcon)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.price)
                }
            } compactLeading: {
                Text(context.state.statusIcon)
            } compactTrailing: {
                Text(context.state.price)
            } minimal: {
                Text(context.state.statusIcon)
            }
        }
    }
}
