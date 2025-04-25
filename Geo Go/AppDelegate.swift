//
//  AppDelegate.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 18/12/24.
//
import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications
import UIKit
import FirebaseCore
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        
        _ = MainViewModel.shared
        
        registerBackgroundTasks()
        
        setupNotificationCategories()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs token registered.")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("FCM registration token: \(token)")
        UserDefaults.standard.set(token, forKey: "fcmToken")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.socketrefresh", using: nil) { task in
            self.handleSocketRefresh(task: task as! BGAppRefreshTask)
        }
        
        scheduleSocketRefresh()
    }
    
    func scheduleSocketRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.socketrefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled socket refresh.")
        } catch {
            print("Could not schedule socket refresh: \(error)")
        }
    }
    
    func handleSocketRefresh(task: BGAppRefreshTask) {
        MainViewModel.shared.connect()
        
        scheduleSocketRefresh()
        
        task.setTaskCompleted(success: true)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        backgroundTaskID = application.beginBackgroundTask(withName: "KeepAlive") {
            application.endBackgroundTask(self.backgroundTaskID)
            self.backgroundTaskID = .invalid
        }
        
        if backgroundTaskID == .invalid {
            print("Failed to start background task.")
        } else {
            print("Background task started.")
        }
    }
    
    // MARK: - Optional: Notification Categories
    func setupNotificationCategories() {
        let rideTrackingCategory = UNNotificationCategory(
            identifier: "rideTracking",
            actions: [],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([rideTrackingCategory])
    }
    
    
}
