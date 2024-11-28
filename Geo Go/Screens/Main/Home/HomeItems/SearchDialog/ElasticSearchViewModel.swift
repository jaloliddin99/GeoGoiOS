//
//  ElasticSearchViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import Foundation

final class ElasticSearchViewModel: ObservableObject{
    
    @Published var reverseLocations: GeocodingResponseModel?
    @Published var alertItem: AlertItem?
    
    func reverseLocation(address: String) {
        NetworkService.shared.sendRequest(
            url: "https://map.uz.taxi/v1/autocomplete",
            params: ["text": address,
                     "boundary.circle.lat": String(DataHolder.location.latitude),
                     "boundary.circle.lon": String(DataHolder.location.longitude),
                     "boundary.circle.radius": "15",
                     "focus.point.lat": String(DataHolder.location.latitude),
                     "focus.point.lon": String(DataHolder.location.longitude),
                     "boundary.country": "UZB",
                     "api_key": Constants.GEOCODE_TOKEN,
                     "size": "15",
                     "sources": "osm"
                    ],
            method: "GET",
            completed: handleAppetizersResponse as (Result<GeocodingResponseModel, APError>) -> Void
        )
    }
    
    private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            switch result {
            case .success(let response):
                if let appetizers = response as? GeocodingResponseModel {
                    self.reverseLocations = appetizers
                }
                
                
            case .failure(let error):
                switch error {
                case .invalidURL:
                    alertItem = AlertContext.invalidURL
                case .invalidResponse:
                    alertItem = AlertContext.invalidResponse
                case .invalidData:
                    alertItem = AlertContext.invalidData
                case .unableToComplete:
                    alertItem = AlertContext.unableToComplete
                }
            }
        }
    }
    
}
