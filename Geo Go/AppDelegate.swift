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
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase setup
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        
        _ = MainViewModel.shared
        
        registerBackgroundTasks()
        
        return true
    }
    
    // Manually handle APNs token registration
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        UserDefaults.standard.set(token, forKey: "fcmToken")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // MARK: - Background Task Management
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.socketrefresh", using: nil) { task in
            self.handleSocketRefresh(task: task as! BGAppRefreshTask)
        }
        
        scheduleSocketRefresh()
    }
    
    func scheduleSocketRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.socketrefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
        
        do {
            try BGTaskScheduler.shared.submit(request)
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
        let backgroundTask = application.beginBackgroundTask {
            // End the task if time expires
        }
        
        if backgroundTask == .invalid {
            print("Failed to start background task")
        }
    }
}
