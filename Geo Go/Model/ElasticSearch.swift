//
//  ElasticSearch.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import Foundation

struct GeocodingResponseModel: Codable {
    var features: [GeocodeFeature]
}

struct GeocodeFeature: Codable {
    var type: String
    var geometry: Geometry
    var properties: GeocodeProperty
}

struct Geometry: Codable {
    var type: String
    var coordinates: [Double]
}

struct GeocodeProperty: Codable {
    var id: String
    var layer: String
    var name: String
    var houseNumber: String?
    var street: String?
    var distance: Double?
    var region: String?
    var label: String?
    var description: String?
}
