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
                self.showNotification(car: car, initialLocation: initialLocation, clientLocation: clientLocation, driverLocation: driverLocation)
                
                self.beginBackgroundTask()
            }
        }
    }
    
    func updateDriverLocation(_ driverLocation: CLLocationCoordinate2D) {
        guard let activeRide = self.activeRide else { return }
        
        showNotification(
            car: activeRide.car,
            initialLocation: activeRide.initialLocation,
            clientLocation: activeRide.clientLocation,
            driverLocation: driverLocation
        )
    }
    
    func stopRideTracking() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [Constants.NOTI_IDENTIFIER])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Constants.NOTI_IDENTIFIER])
        self.activeRide = nil
        
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    private func showNotification(car: CarModel, initialLocation: CLLocationCoordinate2D, clientLocation: CLLocationCoordinate2D, driverLocation: CLLocationCoordinate2D) {
        let content = UNMutableNotificationContent()
        content.title = "Ride Tracking"
        content.body = "Your driver is on the way"
        content.sound = nil
        content.categoryIdentifier = Constants.NOTI_IDENTIFIER
        content.targetContentIdentifier = Constants.NOTI_IDENTIFIER

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
            "driverLon": driverLocation.longitude,
            "useCustomUI": true
        ]
        
        let request = UNNotificationRequest(identifier: Constants.NOTI_IDENTIFIER, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [Constants.NOTI_IDENTIFIER])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Constants.NOTI_IDENTIFIER])
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func beginBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
        }
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }
}
