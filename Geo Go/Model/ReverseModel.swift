//
//  ReverseModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import Foundation

struct UpdateReverseModel:Codable {
    let error: String?
    let address: Address
    let addresstype: String
    let boundingbox: [String]
    let category: String
    let display_name: String?
    let importance: Double
    let lat: String
    let licence: String
    let lon: String
    let name: String?
    let osm_id: Double
    let osm_type: String
    let place_id: Int
    let place_rank: Int
    let type: String
}

struct Address: Codable {
    let house_number: String?
    let residential: String?
    let amenity: String?
    let leisure: String?
    let hamlet: String?
    let district: String?
    let shop: String?
    let city: String?
    let country: String
    let country_code: String
    let county: String?
    let postcode: String
    let road: String?
    let neighbourhood: String?
    let village: String?
    let state: String?
    let town: String?
}
