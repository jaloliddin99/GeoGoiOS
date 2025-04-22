//
//  NotificationViewController.swift
//  RideTrackingNotificationExtension
//
//  Created by Jaloliddin Abdullaev on 21/04/25.
//
import UIKit
import UserNotifications
import UserNotificationsUI
import SwiftUI
import RideTrackingShared
import CoreLocation

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    private var hostingController: UIHostingController<AnyView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up your UI
        view.backgroundColor = .clear
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        let userInfo = content.userInfo
        
        // Extract data from notification payload
        guard let carRegNum = userInfo["carRegNum"] as? String,
              let carBrand = userInfo["carBrand"] as? String,
              let carModel = userInfo["carModel"] as? String,
              let carColor = userInfo["carColor"] as? String,
              let initialLat = userInfo["initialLat"] as? Double,
              let initialLon = userInfo["initialLon"] as? Double,
              let clientLat = userInfo["clientLat"] as? Double,
              let clientLon = userInfo["clientLon"] as? Double,
              let driverLat = userInfo["driverLat"] as? Double,
              let driverLon = userInfo["driverLon"] as? Double else {
            return
        }
        
        // Create objects using shared models
        let car = CarModel(regNum: carRegNum, brand: carBrand, model: carModel, color: carColor)
        let initialLocation = CLLocationCoordinate2D(latitude: initialLat, longitude: initialLon)
        let clientLocation = CLLocationCoordinate2D(latitude: clientLat, longitude: clientLon)
        let driverLocation = DriverLocation(lat: driverLat, lon: driverLon)
        
        // Create view model
        let viewModel = NotificationViewModel(driverLocation: driverLocation)
        
        // Create notification view
        let notificationView =
        RideTrackingNotificationView(
            car: car,
            initialLocation: initialLocation,
            clientLocation: clientLocation,
            viewModel: viewModel
        )
        
        // Set up hosting controller
        if hostingController == nil {
            hostingController = UIHostingController(rootView: AnyView(notificationView))
            addChild(hostingController!)
            view.addSubview(hostingController!.view)
            hostingController!.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController!.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            hostingController!.didMove(toParent: self)
        } else {
            hostingController!.rootView = AnyView(notificationView)
        }
        
        // Adjust the preferred content size
        preferredContentSize = CGSize(width: view.bounds.width, height: 150)
    }
}
