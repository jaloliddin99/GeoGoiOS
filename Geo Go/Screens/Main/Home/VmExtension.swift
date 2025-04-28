//
//  VmExtension.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 27/04/25.
//

import Foundation
import Combine
import SwiftUI
import SocketIO
import ActivityKit
import RideTrackingShared


extension MainViewModel {
    
    
    func sendRideStatusNotification(status: TaxiRideStatus, driverName: String, estimatedTime: Int? = nil) {
        let content = UNMutableNotificationContent()
        switch status {
            case .assigned:
                content.title = NSLocalizedString("driver_assigned_title", comment: "")
                content.body = String(format: NSLocalizedString("driver_assigned_body", comment: ""),
                                      driverName, estimatedTime ?? 0)
                
            case .arrived:
                content.title = NSLocalizedString("driver_arrived_title", comment: "")
                content.body = String(format: NSLocalizedString("driver_arrived_body", comment: ""),
                                      driverName)
                
            case .started:
                content.title = NSLocalizedString("ride_started_title", comment: "")
                content.body = String(format: NSLocalizedString("ride_started_body", comment: ""),
                                      driverName)
                
            case .completed:
                content.title = NSLocalizedString("ride_completed_title", comment: "")
                content.body = String(format: NSLocalizedString("ride_completed_body", comment: ""),
                                      driverName)
        }
        
        content.sound = UNNotificationSound.default
        
        let requestIdentifier = "\(status)-\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request)
    }

    
}
