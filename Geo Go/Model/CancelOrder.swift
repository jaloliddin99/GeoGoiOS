//
//  CancelOrder.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/08/24.
//

import Foundation

struct CancelOrderOptionsModel: Codable {
    let data: [CancelOptionData]
    let message: String
    let status: String
}

struct CancelOptionData: Codable, Identifiable {
    let createdAt: String
    let en: String
    let gr: String
    let id: String
    let kr: String
    let krKrill: String
    let ru: String
    let status: String
    let title: String
    var isChecked: Bool?
    let updatedAt: String
    let uz: String
    let uzKrill: String
}

struct FeedBackPostModel: Codable{
    let complainent: String
    let message: String
    let orderId: Int64
    let type:String
}

struct ResponseFeedback: Codable {
    let message: String
    let status: String
    let error: String?
    let data: String?
}


struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let arrayValue = try? container.decode([AnyCodable].self) {
            value = arrayValue.map { $0.value }
        } else if let dictionaryValue = try? container.decode([String: AnyCodable].self) {
            value = dictionaryValue.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "The container contains nothing serializable.")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else if let arrayValue = value as? [Any] {
            let anyCodableArray = arrayValue.map { AnyCodable($0) }
            try container.encode(anyCodableArray)
        } else if let dictionaryValue = value as? [String: Any] {
            let anyCodableDict = dictionaryValue.mapValues { AnyCodable($0) }
            try container.encode(anyCodableDict)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "The value cannot be encoded"))
        }
    }
}
