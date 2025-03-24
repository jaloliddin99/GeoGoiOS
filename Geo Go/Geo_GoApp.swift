//
//  Geo_GoApp.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import SwiftUI
import Firebase

@main
struct Geo_GoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var restartManager = AppRestartManager()
    @StateObject private var languageManager = LanguageViewModel.shared


    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) {
                HomeScreen()
                    .id(restartManager.key)
                    .environmentObject(restartManager)
                    .environment(\.locale, languageManager.locale)
                    .onAppear {
                        updateLanguage()
                        requestNotificationPermissions()
                    }
            } else {
                AccessScreen()
                    .id(restartManager.key)
                    .environmentObject(restartManager)
                    .environment(\.locale, languageManager.locale)
                    .onAppear {
                        updateLanguage()
                    }
            }
        }
    }
    
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            } else {
                print("Notification permissions granted: \(granted)")
            }
        }
    }

}
