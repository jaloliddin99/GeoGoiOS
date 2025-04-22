//
//  TravelAttributes.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/04/25.
//

import ActivityKit

public struct TravelAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var price: String
        var iconName: String
    }
    
    var tripID: String
}
