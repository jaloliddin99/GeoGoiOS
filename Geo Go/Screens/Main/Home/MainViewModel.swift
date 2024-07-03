//
//  MainScreenViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import Foundation

import Foundation

import SwiftUI
@_spi(Experimental) import MapboxMaps

final class MainViewModel: ObservableObject{
    
    @Published var isShowingMain = false
    
    let tashkent = CLLocationCoordinate2D(latitude: 41.33851520919809, longitude: 69.33460926588599)
    init() {
        MapboxOptions.accessToken = "pk.eyJ1Ijoic2FkdWwiLCJhIjoiY2txNnQwY2VwMDN3MDJucGM0NDZ6YzNybSJ9.K1Pz4WVYeYY0eaqy1tbgWw"
        initMain()
    }
    
    
    private var generateResponse: GenerateResponse?

    func initMain() {
        let url = UserDefaults.standard.string(forKey: Constants.clientApi)!
        let userId = UserDefaults.standard.integer(forKey: Constants.userLoginId)
        let userToken = UserDefaults.standard.string(forKey: Constants.userLoginKey)!
        
        generateResponse = GenerateResponse(userId: userId, userToken: userToken, mainUrl: url)
        
        addressHistory()
    }

    

    @Published var currentAddress: UpdateReverseModel?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    func reverseLocation(lat: Double, lon: Double) {
        isLoading = true
        NetworkService.shared.sendRequest(
            url: UserDefaults().string(forKey: Constants.reverse)!+"reverse",
            params: ["format": Constants.FORMAT,
                     "lat": String(lat),
                     "lon": String(lon),
                     "addressdetails": "1",
                     "accept-language": "uz"
                    ],
            method: "GET",
            headers: ["Accept-Language": "uz"],
            completed: handleAppetizersResponse as (Result<UpdateReverseModel, APError>) -> Void)
    }
    
    private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
            case .success(let response):
                if let appetizers = response as? UpdateReverseModel {
                    print("this is an appetizers \(appetizers)")
                    self.currentAddress = appetizers
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
    
    
    
    
    
    
    @Published var addressHistoryResponse: [ShortOrderInfo]?
    
    func addressHistory() {
        
        guard let responseDetails = generateResponse?.generateHmacData(id: Constants.HISTORY) else { return }

        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            method: "GET",
            headers: [
                "Accept-Language": "uz",
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            completed: handleAddressHistoryResponse as (Result<[ShortOrderInfo], APError>) -> Void)
    }
    
    private func handleAddressHistoryResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
            case .success(let response):
                if let appetizers = response as? [ShortOrderInfo] {
                    self.addressHistoryResponse = appetizers
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
