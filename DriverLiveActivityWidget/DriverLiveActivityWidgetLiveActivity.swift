//
//  DriverLiveActivityWidgetLiveActivity.swift
//  DriverLiveActivityWidget
//
//  Created by Jaloliddin Abdullaev on 25/04/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DriverLiveActivityWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DriverLiveActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DriverLiveActivityWidgetAttributes.self) { context in
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

extension DriverLiveActivityWidgetAttributes {
    fileprivate static var preview: DriverLiveActivityWidgetAttributes {
        DriverLiveActivityWidgetAttributes(name: "World")
    }
}

extension DriverLiveActivityWidgetAttributes.ContentState {
    fileprivate static var smiley: DriverLiveActivityWidgetAttributes.ContentState {
        DriverLiveActivityWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DriverLiveActivityWidgetAttributes.ContentState {
         DriverLiveActivityWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DriverLiveActivityWidgetAttributes.preview) {
   DriverLiveActivityWidgetLiveActivity()
} contentStates: {
    DriverLiveActivityWidgetAttributes.ContentState.smiley
    DriverLiveActivityWidgetAttributes.ContentState.starEyes
}
