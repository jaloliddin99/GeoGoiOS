//
//  AppRestartManager.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/03/25.
//

import SwiftUI

class AppRestartManager: ObservableObject {
    @Published var key = UUID() // Unique ID to force view reload
    
    func restartApp() {
        key = UUID() // Changing UUID will reinitialize the view hierarchy
    }
}
