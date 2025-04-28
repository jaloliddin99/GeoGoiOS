//
//  DriverLocation.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//

import Foundation
import SwiftUI
import ActivityKit
import CoreLocation

public struct DriverActivityAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        public let currentLat: Double
        public let currentLon: Double
        public let speed: Double
        public init(currentLat: Double, currentLon: Double, speed: Double) {
            self.currentLat = currentLat
            self.currentLon = currentLon
            self.speed = speed
        }
    }
    
    public let initialLat: Double
    public let initialLon: Double
    public let clientLat: Double
    public let clientLon: Double
    
    public let regNum: String
    public let brand: String
    public let model: String
    public let color: String
    
    public init(initialLat: Double, initialLon: Double,
                clientLat: Double, clientLon: Double,
                regNum: String, brand: String, model: String, color: String) {
        self.initialLat = initialLat
        self.initialLon = initialLon
        self.clientLat = clientLat
        self.clientLon = clientLon
        self.regNum = regNum
        self.brand = brand
        self.model = model
        self.color = color
    }
}

public extension DriverActivityAttributes {
    
    func calculateProgress(using state: ContentState) -> (arrivalTime: Int, sliderValue: Float) {
        let initialLocation = CLLocationCoordinate2D(latitude: initialLat, longitude: initialLon)
        let clientLocation = CLLocationCoordinate2D(latitude: clientLat, longitude: clientLon)
        let currentLocation = CLLocationCoordinate2D(latitude: state.currentLat, longitude: state.currentLon)
        
        
        let distanceCurrentToInitial = currentLocation.distance(to: initialLocation)
        print("distanceCurrentToInitial \(distanceCurrentToInitial)")

        let distanceCurrentToClient = currentLocation.distance(to: clientLocation)
        print("distanceCurrentToClient \(distanceCurrentToClient)")

        let totalDistance = distanceCurrentToInitial + distanceCurrentToClient
        
        // Speed in meters per second (assuming 15 m/s ~ 54 km/h)
        let speed: Double = state.speed
        print("speed \(state.speed)")

        let remainingTimeInSeconds = distanceCurrentToClient / speed
        
        print("remainingTimeInSeconds \(remainingTimeInSeconds)")

        let remainingTimeInMinutes = Int(remainingTimeInSeconds) / 60
        print("remainingTimeInMinutes \(remainingTimeInMinutes)")

        let progress = (distanceCurrentToInitial / totalDistance) * 100
        
        print("progress \(progress)")

        let progressFloat = Float(progress)
        
        
        return (arrivalTime: remainingTimeInMinutes, sliderValue: progressFloat)
    }
}



public struct FinishOrderAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        public let orderAmount: String
        public let bonusAmount: String?
        public let regNum: String
        
        public init(orderAmount: String, bonusAmount: String?,
                    regNum: String) {
            self.orderAmount = orderAmount
            self.bonusAmount = bonusAmount
            self.regNum = regNum
        }
    }
    
    public let orderAmount: String
    public let bonusAmount: String?
    public let regNum: String
    
    public init(orderAmount: String, bonusAmount: String?,
                regNum: String) {
        self.orderAmount = orderAmount
        self.bonusAmount = bonusAmount
        self.regNum = regNum
    }
}

extension CLLocationCoordinate2D {
    /// Calculates the distance in meters between two coordinates.
    func distance(to coordinate: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let toLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return fromLocation.distance(from: toLocation) // distance in meters
    }
}
