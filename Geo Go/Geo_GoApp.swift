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
    @StateObject private var languageViewModel = LanguageViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) {
                HomeScreen()
                    .environmentObject(languageViewModel)
                    .onAppear {
                        updateLanguage()
                        requestNotificationPermissions()
                    }
            } else {
                AccessScreen()
                    .environmentObject(languageViewModel)
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
