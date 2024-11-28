//
//  DateOrderHistory.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/08/24.
//

import Foundation


struct DateOrderHistory: Codable, Identifiable {
    let check: [Check]
    let completionDate: String
    let route: [Route]
    let toPay: Double
    let total: Double
    let usedBonuses: Double
    var id: Int64? = nil
}

struct Check: Codable {
    let cost: Double
    let title: String
}

struct Route: Codable {
    let address: RouteAddress
    let comment: String?
}

struct RouteAddress: Codable {
    let components: [Component]
    let name: String
    let position: Position
}

struct Component : Codable{
    let level: Double
    let name: String
}

struct Position: Codable {
    let lat: Double
    let lon: Double
}
