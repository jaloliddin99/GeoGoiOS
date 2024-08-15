//
//  AddressHistory.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//


import Foundation

struct ShortOrderInfo: Codable{
    let id: Int64
    var state: Int
    var route: [SearchedAddress]
    var assignee: Assignee?
    var time: String?
    let needsProlongation: Bool?
    let cost: Cost?
}

struct OrderHistory: Codable, Identifiable{
    let id: Int64
    let state: Int
    let route: [SearchedAddress]
    let assignee: Assignee?
    let time: String?
    let needsProlongation: Bool?
    var total: Int = 0
}

struct Assignee: Codable {
    let car: TaxiCar
}

struct TaxiCar: Codable {
    let brand: String
    var model: String
    let color: String
    let regNum: String
}


struct Cost: Codable {
    let type: String
    let amount: Double
    let calculation: String
    var modifier: CostModifier?
    var fixed: Double?
    var details: [CostItem]?
}

struct CostItem: Codable {
    let title: String
    let cost: Double
}

struct CostModifier: Codable {
    let type: String
    let value: Double
}

struct SearchedAddress: Codable {
    
    
    let name: String
    var components: [SearchComponent]?
    var types: AddressTypes?
    var position: SearchPosition?
}

struct SearchComponent: Codable {
    let level: Int
    let name: String
}


struct AddressTypes: Codable {
    var pointType: Int?
    var aliasType: Int?
}

struct SearchPosition : Codable{
    let lat: Double
    let lon: Double
}
