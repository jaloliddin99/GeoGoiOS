//
//  RideTrackingNotificationService.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//
import UIKit
import UserNotifications
import CoreLocation
import RideTrackingShared

class RideTrackingNotificationService {
    static let shared = RideTrackingNotificationService()
    
    private var activeRide: (car: CarModel, initialLocation: CLLocationCoordinate2D, clientLocation: CLLocationCoordinate2D)?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func startRideTracking(car: CarModel, initialLocation: CLLocationCoordinate2D, clientLocation: CLLocationCoordinate2D, driverLocation: CLLocationCoordinate2D) {
        self.activeRide = (car, initialLocation, clientLocation)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard granted else { return }
            
            DispatchQueue.main.async {
                // Create and show initial notification
                self.showNotification(car: car, initialLocation: initialLocation, clientLocation: clientLocation, driverLocation: driverLocation)
                
                // Start background task
                self.beginBackgroundTask()
            }
        }
    }
    
    // Update notification with new driver location
    func updateDriverLocation(_ driverLocation: CLLocationCoordinate2D) {
        guard let activeRide = self.activeRide else { return }
        
        // Create notification with updated location
        showNotification(
            car: activeRide.car,
            initialLocation: activeRide.initialLocation,
            clientLocation: activeRide.clientLocation,
            driverLocation: driverLocation
        )
    }
    
    // Stop tracking notification
    func stopRideTracking() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["rideTracking"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["rideTracking"])
        self.activeRide = nil
        
        // End background task
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    // Helper method to create and show the notification
    private func showNotification(car: CarModel, initialLocation: CLLocationCoordinate2D, clientLocation: CLLocationCoordinate2D, driverLocation: CLLocationCoordinate2D) {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Ride Tracking"
        content.body = "Your driver is on the way"
        content.sound = nil  // No sound for updates
        content.categoryIdentifier = "rideTracking"
        
        // Add all required data to user info
        content.userInfo = [
            "carRegNum": car.regNum,
            "carBrand": car.brand,
            "carModel": car.model,
            "carColor": car.color,
            "initialLat": initialLocation.latitude,
            "initialLon": initialLocation.longitude,
            "clientLat": clientLocation.latitude,
            "clientLon": clientLocation.longitude,
            "driverLat": driverLocation.latitude,
            "driverLon": driverLocation.longitude
        ]
        
        // Create notification request
        let request = UNNotificationRequest(identifier: "rideTracking", content: content, trigger: nil)
        
        // Remove any existing notification first
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["rideTracking"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["rideTracking"])
        
        // Add the new notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error.localizedDescription)")
            }
        }
    }
    
    // Begin background task to extend app's runtime
    private func beginBackgroundTask() {
        // End previous task if it exists
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
        }
        
        // Start new background task
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }
}
