//
//  Geo_GoApp.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import SwiftUI

@main
struct Geo_GoApp: App {
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn){
                HomeScreen()
            }else{
                AccessScreen()
            }
        }
    }
}
