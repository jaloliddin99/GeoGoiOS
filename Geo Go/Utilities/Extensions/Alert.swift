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
        title: Text("alert_title_server_error"),
        message: Text("alert_message_invalid_data"),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidResponse = AlertItem(
        title: Text("alert_title_server_error"),
        message: Text("alert_message_invalid_response"),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidURL = AlertItem(
        title: Text("alert_title_server_error"),
        message: Text("alert_message_invalid_url"),
        dismissButton: .default(Text("OK"))
    )
    
    static let unableToComplete = AlertItem(
        title: Text("alert_title_server_error"),
        message: Text("alert_message_unable_to_complete"),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidForm = AlertItem(
        title: Text("alert_title_invalid_form"),
        message: Text("alert_message_invalid_form"),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidEmail = AlertItem(
        title: Text("alert_title_invalid_email"),
        message: Text("alert_message_invalid_email"),
        dismissButton: .default(Text("OK"))
    )
    
    static let userSaveSuccess = AlertItem(
        title: Text("alert_title_profile_saved"),
        message: Text("alert_message_profile_saved"),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidUserData = AlertItem(
        title: Text("alert_title_profile_error"),
        message: Text("alert_message_profile_error"),
        dismissButton: .default(Text("OK"))
    )
}
