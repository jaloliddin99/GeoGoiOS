//
//  Alert.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import Foundation
import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidData = AlertItem(
        title: Text("alert_title_server_error".localize()),
        message: Text("alert_message_invalid_data".localize()),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidResponse = AlertItem(
        title: Text("alert_title_server_error".localize()),
        message: Text("alert_message_invalid_response".localize()),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidURL = AlertItem(
        title: Text("alert_title_server_error".localize()),
        message: Text("alert_message_invalid_url".localize()),
        dismissButton: .default(Text("OK"))
    )
    
    static let unableToComplete = AlertItem(
        title: Text("alert_title_server_error".localize()),
        message: Text("alert_message_unable_to_complete".localize()),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidForm = AlertItem(
        title: Text("alert_title_invalid_form".localize()),
        message: Text("alert_message_invalid_form".localize()),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidEmail = AlertItem(
        title: Text("alert_title_invalid_email".localize()),
        message: Text("alert_message_invalid_email".localize()),
        dismissButton: .default(Text("OK"))
    )
    
    static let userSaveSuccess = AlertItem(
        title: Text("alert_title_profile_saved".localize()),
        message: Text("alert_message_profile_saved".localize()),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidUserData = AlertItem(
        title: Text("alert_title_profile_error".localize()),
        message: Text("alert_message_profile_error".localize()),
        dismissButton: .default(Text("OK"))
    )
}
