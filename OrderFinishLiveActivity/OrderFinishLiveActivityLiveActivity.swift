//
//  OrderFinishLiveActivityLiveActivity.swift
//  OrderFinishLiveActivity
//
//  Created by Jaloliddin Abdullaev on 26/04/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderFinishLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct OrderFinishLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderFinishLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension OrderFinishLiveActivityAttributes {
    fileprivate static var preview: OrderFinishLiveActivityAttributes {
        OrderFinishLiveActivityAttributes(name: "World")
    }
}

extension OrderFinishLiveActivityAttributes.ContentState {
    fileprivate static var smiley: OrderFinishLiveActivityAttributes.ContentState {
        OrderFinishLiveActivityAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: OrderFinishLiveActivityAttributes.ContentState {
         OrderFinishLiveActivityAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: OrderFinishLiveActivityAttributes.preview) {
   OrderFinishLiveActivityLiveActivity()
} contentStates: {
    OrderFinishLiveActivityAttributes.ContentState.smiley
    OrderFinishLiveActivityAttributes.ContentState.starEyes
}
