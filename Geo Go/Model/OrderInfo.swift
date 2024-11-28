//
//  OrderInfo.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/08/24.
//

import Foundation


struct OrderInfo: Codable {
    let state: Int
    let costFixAllowed: Bool?
    let route: [RouteItem]
    let assignee: AsigneeBody?
    let options: [Int64]?
    let time: String?
    let needsProlongation: Bool?
    let comment: String?
    let distance: Double?
    let cost: Cost
    let executionTime: String?
    let usedBonuses: Double?
    let paymentMethod: PaymentMethod?
    let costChangeAllowed: Bool?
    let costChangeStep: Bool?
    let isComing: Bool?
    let paidWaitingStartsAt: String?
}

struct RouteItem: Codable {
    var point: RoutePoint
}
struct RoutePoint: Codable {
    var info: Info
    var coordinates: Coordinates
}
struct Info: Codable {
    var alias: String
}
struct Coordinates: Codable {
    var lon: Double
    var lat: Double
}


struct AsigneeBody: Codable {
    let car: Car
    let location: SearchPosition?
    let call: AssigneeCall
}

struct Car: Codable {
    let alias: String?
    let brand: String
    let model: String
    let color: String
    let regNum: String
}

struct AssigneeCall: Codable {
    let allow: String
    let numbers: [String]?
}

