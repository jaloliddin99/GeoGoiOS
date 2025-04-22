//
//  SocketManagerService.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 20/04/25.
//

import Foundation
import SocketIO
import CoreLocation
import UserNotifications
import UIKit


class SocketManagerService: NSObject, ObservableObject {
    static let shared = SocketManagerService() // Singleton instance
    
    @Published var sOrderInfo: SOrderInfo?
    @Published var sDriverRealTimeData: SDriverRealTimeData?
    @Published var sDriverLists: [SDriverData] = []
    @Published var isLocationSharingEnabled = false
    
    private var locationManager = LocationManager()
    private var locationTimer: Timer?
    private var timerIntervalSeconds: Double = 5
    
    private var socketManager: SocketManager!
    var socket: SocketIOClient!
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    private override init() {
        super.init()
        setupSocket()
        registerForNotifications()
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc private func appDidEnterBackground() {
        // Start background task
        beginBackgroundTask()
    }
    
    @objc private func appWillEnterForeground() {
        // End background task if it's active
        endBackgroundTask()
    }
    
    private func beginBackgroundTask() {
        // End previous task if exists
        endBackgroundTask()
        
        // Create a new background task
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    private func setupSocket() {
        socketManager = SocketManager(
            socketURL: URL(string: "http://185.224.219.1:3007")!,
            config: [
                .log(false),
                .forceWebsockets(true),
                .reconnectAttempts(5),
                .reconnectWait(5)
            ]
        )
        socket = socketManager.defaultSocket
        socket.on(clientEvent: .connect) { _, _ in
            print("socketLog connected")
            self.setupInitialListeners()
        }
        socket.on(clientEvent: .disconnect) { data, _ in
            print("socketLog Disconnected with data: \(data)")
        }
        socket.on(clientEvent: .error) { data, _ in
            print("socketLog error with data: \(data)")
        }
        socket.on(clientEvent: .reconnect) { _, _ in
            print("socketLog reconnect")
        }
        socket.on(clientEvent: .reconnectAttempt) { _, _ in
            print("socketLog reconnectAttempt")
        }
        connect()
    }
    
    private func setupInitialListeners() {
        attachUser()
        attachGetCars()
        if let orderId = DataHolder.orderId, orderId > 0 {
            sendUserOrderIdAndLocs(orderId: DataHolder.orderId)
        }
    }
    
    func updateLocationSharing(_ isEnabled: Bool) {
        isLocationSharingEnabled = isEnabled
        if isEnabled {
            requestUserLocation()
            startLocationTimer()
        } else {
            stopLocationTimer()
        }
    }
    
    func requestUserLocation() {
        locationManager.requestLocation()
    }
    
    private func startLocationTimer() {
        stopLocationTimer()
        locationTimer = Timer.scheduledTimer(withTimeInterval: timerIntervalSeconds, repeats: true) { _ in
            self.sendLocationToSocket()
        }
    }
    
    private func stopLocationTimer() {
        locationTimer?.invalidate()
        locationTimer = nil
    }
    
    func sendLocationToSocket() {
        guard isLocationSharingEnabled,
              let coordinate = locationManager.location?.coordinate else { return }
        
        let data: [String: Any] = [
            "orderId": DataHolder.orderId,
            "departureLocation": [coordinate.latitude, coordinate.longitude]
        ]
        socket.emit("listen-order", data)
    }
    
    func connect() {
        if socket.status == .connected {
            return
        }
        socket.connect()
    }
    
    func disconnect() {
        guard socket.status != .disconnected else { return }
        socket.disconnect()
        socket.removeAllHandlers()
    }
    
    deinit {
        disconnect()
        stopLocationTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    private var statusHolder: Int = -1
    func sendUserOrderIdAndLocs(orderId: Int64){
        let message = ModelSend(
            orderId: orderId,
            departureLocation: [DataHolder.location.latitude, DataHolder.location.longitude]
        )
        if let messageData = message.toDictionary() {
            socket.off("listen-order")
            socket.off("getCars")
            socket.emit("listen-order", messageData)
            
            socket.on("listen-order") { [weak self] data, ack in
                guard let self = self else { return }
                
                if let orderInfo: SOrderInfo = parseSocketData(data: data, type: SOrderInfo.self) {
                    print("listen-order received \(orderInfo)")
                    switch orderInfo.orderStatus {
                        case 2:
                            sendRideStatusNotification(status: .assigned, driverName: orderInfo.driverFullName, estimatedTime: 2)
                            getOrderDetails(orderId: orderId, true)
                            listenAttachedDriverLocation()
                            
                        case 3:
                            sendRideStatusNotification(status: .arrived, driverName: orderInfo.driverFullName)
                            
                        case 4:
                            sendRideStatusNotification(status: .started, driverName: orderInfo.driverFullName)
                            
                        case 5:
                            sendRideStatusNotification(status: .completed, driverName: orderInfo.driverFullName)
                            getOrderDetails(orderId: orderId, true)
                            
                        case 7:
                            setDefaults()
                            
                        default:
                            break
                    }
                    
                    handleUIByOrderStatus(orderInfo.orderStatus)
                    self.sOrderInfo = orderInfo
                    
                    // Notify ViewModel about order update
                    NotificationCenter.default.post(name: Notification.Name("OrderInfoUpdated"), object: orderInfo)
                }
            }
        }
    }
    
    func sendRideStatusNotification(status: TaxiRideStatus, driverName: String, estimatedTime: Int? = nil) {
        let content = UNMutableNotificationContent()
        print("status :  \(status) \(driverName)")
        
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
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }
    
    func attachUser(){
        let message = Message(
            lat: DataHolder.location.latitude,
            long: DataHolder.location.longitude,
            userId: getUserPhone(),
            type: "all"
        )
        
        if let messageData = message.toDictionary() {
            socket.emit("user", messageData)
        }
    }
    
    private func attachGetCars(){
        socket.off("getCars")
        socket.on("getCars"){ data, ack in
            if let cars: [SDriverData] = parseSocketData(data: data, type: [SDriverData].self) {
                DispatchQueue.main.async {
                    self.sDriverLists = cars
                    NotificationCenter.default.post(name: Notification.Name("DriverListsUpdated"), object: cars)
                }
            }
        }
    }
    
    func listenAttachedDriverLocation(){
        socket.off("update-driver-location")
        socket.on("update-driver-location"){ data, ack in
            print("update-driver-location received \(data)")
            if let rtd: SDriverRealTimeData = parseSocketData(data: data, type: SDriverRealTimeData.self) {
                DispatchQueue.main.async {
                    self.sDriverRealTimeData = rtd
                    // Notify ViewModel about driver location update
                    NotificationCenter.default.post(name: Notification.Name("DriverLocationUpdated"), object: rtd)
                }
            }
        }
    }
}

// Helper function for parsing socket data
