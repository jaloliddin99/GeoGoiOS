//
//  DriverLiveActivityWidgetBundle.swift
//  DriverLiveActivityWidget
//
//  Created by Jaloliddin Abdullaev on 25/04/25.
//

import WidgetKit
import SwiftUI

@main
struct DriverLiveActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        DriverLiveActivityWidget()
        DriverLiveActivityWidgetControl()
        DriverLiveActivityWidgetLiveActivity()
    }
}
