//
//  DriverLiveActivityWidget.swift
//  DriverLiveActivityWidget
//
//  Created by Jaloliddin Abdullaev on 25/04/25.
//

import WidgetKit
import SwiftUI
import RideTrackingShared

struct DriverLiveActivityWidget: Widget {
    let kind: String = "DriverLiveActivityWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DriverActivityAttributes.self) { context in
            RideTrackingNotificationView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Image("car_from_above_2")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(90))
                            .frame(width: 30, height: 30)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    let (arrivalTime, _) = context.attributes.calculateProgress(using: context.state)

                    Text("\(arrivalTime) \(LocalizedStringResource("min"))")
                        .font(.headline)
                        .lineLimit(1)
                }
                DynamicIslandExpandedRegion(.bottom) {

                }
            } compactLeading: {
                Image("car_from_above_2")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(90))
                    .frame(width: 30, height: 30)
            } compactTrailing: {
                
                let (arrivalTime, _) = context.attributes.calculateProgress(using: context.state)
                Text("\(arrivalTime) \(LocalizedStringResource("min"))")
                    .font(.headline)
                    .lineLimit(1)
                
            } minimal: {
                Image("car_from_above_2")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(90))
                    .frame(width: 30, height: 30)
            }
        }
    }
}
