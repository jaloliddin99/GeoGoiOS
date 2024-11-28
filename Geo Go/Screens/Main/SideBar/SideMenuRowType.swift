//
//  SideMenuRowType.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import Foundation


enum SideMenuRowType: Int, CaseIterable{
    case trips = 0
    case paymentMethod
    case favouriteAddresses
    case discount
    case settings
    case news
    case support
    
    var title: String{
        switch self {
        case .trips:
            return "My Trips"
        case .paymentMethod:
            return "Payment method"
        case .favouriteAddresses:
            return "Favourite addresses"
        case .discount:
            return "Discount"
            
        case .settings:
            return "Settings"
            
        case .news:
            return "News"
        case .support:
            return "Support"
            
        }
    }
    
    var iconName: String{
        switch self {
        case .trips:
            return "home"
        case .paymentMethod:
            return "creditcard"
        case .favouriteAddresses:
            return "chat"
        case .discount:
            return "profile"
            
        case .settings:
            return "chat"
        case .news:
            return "newspaper"
        case .support:
            return "profile"
        }
        
    }
    
}
