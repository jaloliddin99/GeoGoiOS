//
//  ElasticSearch.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import Foundation



struct GeocodingResponseModel: Codable {
    let lat: Double
    let lon: Double
    let displayName: String
    let address: AAddress
    let distance: Double
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, address, distance, unit
        case displayName = "display_name"
    }
}

struct AAddress: Codable {
    let road: String
    let country: String
    let countryCode: String
    
    enum CodingKeys: String, CodingKey {
        case road, country
        case countryCode = "country_code"
    }
}
