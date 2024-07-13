//
//  Estimate.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 08/07/24.
//

import Foundation

// estimate response

struct EstimateResponse: Codable {
    let cost: EstimateCost
    let distance: Double
}

struct EstimateCost: Codable {
    var type: String
    let amount: Double
    let modifier: EstimateCostModifier?
    let calculation: String
}

struct EstimateCostModifier: Codable {
    let type: String?
    let value: Double?
}


// estimate body

struct EstimateRideRequest: Codable {
    let tariff: Int64
    let paymentMethod: PaymentMethod
    let options: [Int64]?
    let route: [RouteCoordinates]
}

struct RouteCoordinates: Codable {
    let lat : Double
    let lon : Double
    let type : String?
}
