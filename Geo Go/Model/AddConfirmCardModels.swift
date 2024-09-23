//
//  AddConfirmCardModels.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/09/24.
//

import Foundation


struct ModelAddCardResponse: Codable {
    let success: Bool
    let error: String?
    let phone: String?
    let result: AddCardResult?
    let transaction_id: Int?
    let id: Int?
}

struct AddCardResult: Codable {
    let code: String
    let description: String
}

struct ModelAddCard: Codable {
    let card_number: String
    let expiry: String
    let userId: String
}

struct ModelConfirmCard: Codable {
    let otp: String
    let transaction_id: Int
    let userId: String
    let card_name: String
    let id: String
}

struct ModelConfirmCardResponse: Codable {
    let data: DataX?
    let status: String?
    let success: Bool
    let error: String?
}

struct DataX: Codable {
    let card_expiry: String
    let card_holder: String
    let card_number: String
    let card_name: String
    let card_pan: String
    let card_token: String
    let createdAt: String
    let is_main: Bool
    let id: Int
    let updatedAt: String
    let userId: Int
    let confirmed: Bool
}


struct ModelGetCards: Codable {
    let data: [CardData]?
    let status: String?
    let success: Bool
    let error: String?
}

struct CardData: Codable {
    let cardExpiry: String
    let cardHolder: String
    let cardId: String?
    let cardPan: String
    let cardToken: String
    let createdAt: String
    let id: Int
    let isMain: Bool
    let updatedAt: String
    let userId: Int
    let cardName: String
    let confirmed: Bool
    
    enum CodingKeys: String, CodingKey {
        case cardExpiry = "card_expiry"
        case cardHolder = "card_holder"
        case cardId = "card_id"
        case cardPan = "card_pan"
        case cardToken = "card_token"
        case createdAt = "createdAt"
        case id
        case isMain = "is_main"
        case updatedAt = "updatedAt"
        case userId = "userId"
        case cardName = "card_name"
        case confirmed
    }
}



struct ModelUpdateCardAsMain: Codable{
    let is_main: Bool
    let userId: String
}
