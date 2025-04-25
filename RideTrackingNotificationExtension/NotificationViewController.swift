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
        print("NotificationViewController: viewDidLoad called")
        view.backgroundColor = .clear
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        let userInfo = content.userInfo
        print("NotificationViewController: didReceive called")
        print("UserInfo: \(notification.request.content.userInfo)")
      
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
        print("Hello world these are the comment \(carRegNum)")

        
        let car = CarModel(regNum: carRegNum, brand: carBrand, model: carModel, color: carColor)
        let initialLocation = CLLocationCoordinate2D(latitude: initialLat, longitude: initialLon)
        let clientLocation = CLLocationCoordinate2D(latitude: clientLat, longitude: clientLon)
        let driverLocation = DriverLocation(lat: driverLat, lon: driverLon)
        
        let viewModel = NotificationViewModel(driverLocation: driverLocation)
        
        let notificationView =
        RideTrackingNotificationView(
            car: car,
            initialLocation: initialLocation,
            clientLocation: clientLocation,
            viewModel: viewModel
        )
        
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
        
        preferredContentSize = CGSize(width: view.bounds.width, height: 150)
    }
}
