//
//  NotificationViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//

import Foundation
import SwiftUI
import Combine

public class NotificationViewModel: ObservableObject {
    @Published public var driverLocation: DriverLocation?
    
    public init(driverLocation: DriverLocation? = nil) {
        self.driverLocation = driverLocation
    }
    
    public func updateDriverLocation(_ location: DriverLocation) {
        self.driverLocation = location
    }
}
