//
//  OrderFinishLiveActivity.swift
//  OrderFinishLiveActivity
//
//  Created by Jaloliddin Abdullaev on 26/04/25.
//

import WidgetKit

import WidgetKit
import SwiftUI
import RideTrackingShared

struct OrderFinishLiveActivity: Widget {
    let kind: String = "OrderFinishLiveActivity"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FinishOrderAttributes.self) { context in
            RideEndSubmitView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { }
                DynamicIslandExpandedRegion(.trailing) { }
                DynamicIslandExpandedRegion(.bottom) { }
            } compactLeading: {
                EmptyView()
            } compactTrailing: {
                EmptyView()
            } minimal: {
                EmptyView()
            }
        }
    }
}

