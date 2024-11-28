//
//  CreateOrder.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 01/08/24.
//

import Foundation


struct CreateOrderRequest:Codable {
    var paymentMethod: PaymentMethod
    var tariff: Int64?
    var options: [Int64]
    var route: [ClientAddress]
    var time: OrderTime?
    var comment: String?
    var fixCost: Double?
    var useBonuses: Double?
    var disableSms: Bool?
    var disableVoice: Bool?
    var enablePushUpdates: Bool?
    var estimationToken: String?
}

struct OrderTime: Codable {
    var type: String
    var value: String
}

struct CreateOrderResponse: Codable {
    var id: Int64
}


struct ClientAddress :Codable {
    let address: SearchedAddress?
    let entrance: String?
    let flat: String?
    let comment: String?
    let pickupPointId: Int64?
}

struct EmptyModel: Codable{
    let dummy: String?
}
