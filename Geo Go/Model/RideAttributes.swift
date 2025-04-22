//
//  RideAttributes.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/04/25.
//


import ActivityKit

struct RideAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var price: String
        var statusIcon: String
    }
    
    var rideId: String 
}
