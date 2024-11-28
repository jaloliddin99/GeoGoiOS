//
//  Geo_GoApp.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//
import SwiftUI
@main
struct Geo_GoApp: App {
    @StateObject private var languageViewModel = LanguageViewModel()
    @State private var isRestarting = false
    
    var body: some Scene {
        WindowGroup {
            if isRestarting {
                EmptyView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isRestarting = false
                        }
                    }
            } else {
                if UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) {
                    HomeScreen()
                        .environmentObject(languageViewModel)
                        .onAppear {
                            updateLanguage()
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
        .onChange(of: languageViewModel.restartApp) { shouldRestart in
            if shouldRestart {
                isRestarting = true
                languageViewModel.restartApp = false
            }
        }
    }
}
