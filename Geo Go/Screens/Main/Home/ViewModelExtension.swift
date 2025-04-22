//
//  ViewModelExtension.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//

import Foundation
import CoreLocation
import RideTrackingShared
import UIKit

// Extension to handle notification functionality
extension MainViewModel {
    
    public var isRideActive: Bool {
        return self.currentCar != nil && self.initialDriverLocation != nil && self.clientLocation != nil
    }
    
    
    func startRideTracking(car: CarModel, initialLocation: CLLocationCoordinate2D, clientLocation: CLLocationCoordinate2D) {
        self.currentCar = car
        self.initialDriverLocation = initialLocation
        self.clientLocation = clientLocation
        
        // Get current driver location
        guard let driverData = sDriverRealTimeData else { return }
        let driverLocation = CLLocationCoordinate2D(latitude: driverData.lat, longitude: driverData.lon)
        
        RideTrackingNotificationService.shared.startRideTracking(
            car: car,
            initialLocation: initialLocation,
            clientLocation: clientLocation,
            driverLocation: driverLocation
        )
    }
    
    // Stop ride tracking notification
    func stopRideTracking() {
        self.currentCar = nil
        self.initialDriverLocation = nil
        self.clientLocation = nil
        
        RideTrackingNotificationService.shared.stopRideTracking()
    }
    
    // Observer for driver location changes
    func didUpdateDriverLocation() {
        // Check if we have an active ride and app is in background
        if isRideActive && UIApplication.shared.applicationState != .active {
            updateNotificationWithDriverLocation()
        }
    }
    
    // Update notification with new driver location
    private func updateNotificationWithDriverLocation() {
        guard let driverData = sDriverRealTimeData else { return }
        
        let driverLocation = CLLocationCoordinate2D(latitude: driverData.lat, longitude: driverData.lon)
        RideTrackingNotificationService.shared.updateDriverLocation(driverLocation)
    }
    
}
