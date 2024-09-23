//
//  Discount.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 29/08/24.
//

import Foundation


struct PromoCodeSend: Codable{
    let value: String
}

struct RequestPromoCode: Codable {
    let date: String
    let phone: String
    let promocode_amount: Int
    let promocode_name: String
}

struct PromoCodeResponse: Codable{
    let amount: Double
}

struct ResponsePromoCode: Codable {
    let data: PromoItem
    let error: String?
    let message: String
    let status: String
}


struct PostPromoCodeResponse: Codable {
    let data: Content
    let error: String?
    let message: String
    let status: String
}



struct PromoItem: Codable {
    let content: [Content]
    let pagination: Pagination
}

struct Content: Codable, Hashable {
    let createdAt: String
    let date: String
    let id: Int
    let phone: String
    let promocode_amount: String
    let promocode_name: String
    let updatedAt: String
}

struct Pagination: Codable {
    let allItemsCount: Int
    let allPagesCount: Int
    let isFirstPage: Bool
    let isLastPage: Bool
    let page: Int
}
