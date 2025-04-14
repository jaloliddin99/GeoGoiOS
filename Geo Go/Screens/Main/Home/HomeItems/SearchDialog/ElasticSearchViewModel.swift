//
//  ElasticSearchViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import Foundation
import Combine


final class ElasticSearchViewModel: ObservableObject{
    
    @Published var reverseLocations: [GeocodingResponseModel]?
    
    func reverseLocation(address: String) {
        NetworkService.shared.sendRequest(
            url: "https://search.uz.taxi/address",
            params: ["text": address,
                     "boundary.circle.lat": String(DataHolder.location.latitude),
                     "boundary.circle.lon": String(DataHolder.location.longitude),
                     "boundary.circle.radius": "15",
                     "focus.point.lat": String(DataHolder.location.latitude),
                     "focus.point.lon": String(DataHolder.location.longitude),
                     "boundary.country": "UZB",
                     "api_key": Constants.GEOCODE_TOKEN,
                     "size": "15",
                     "lang": DataHolder.lang,
                     "sources": "osm"
                    ],
            method: "GET",
            isPrintable: true
        ){ [weak self] (result: Result<[GeocodingResponseModel], APError>) in
            DispatchQueue.main.async { [self] in
                switch result {
                    case .success(let locations):
                        self?.reverseLocations = locations

                    case .failure(let error):
                        print("API error: \(error)")
                }
            }
        }
    }
    
}
