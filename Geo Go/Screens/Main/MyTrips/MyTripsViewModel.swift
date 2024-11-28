//
//  MyTripsViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/08/24.
//

import SwiftUI

final class MyTripsViewModel: ObservableObject{
    
    
//    init() {
//        initMain()
//    }
//    
//    private var generateResponse: GenerateResponse?
//    
//    func initMain() {
//        let url = UserDefaults.standard.string(forKey: Constants.clientApi)!
//        let userId = UserDefaults.standard.integer(forKey: Constants.userLoginId)
//        let userToken = UserDefaults.standard.string(forKey: Constants.userLoginKey)!
//        generateResponse = GenerateResponse(userId: userId, userToken: userToken, mainUrl: url)
//    }
//    
//    
//    @Published var addressHistoryResponse: [ShortOrderInfo]?
//    
//    func addressHistory() {
//        
//        guard let responseDetails = generateResponse?.generateHmacData(id: Constants.HISTORY) else { return }
//        
//        NetworkService.shared.sendRequest(
//            url: responseDetails.url,
//            method: "GET",
//            headers: [
//                "Accept-Language": "uz",
//                "Hive-Profile": Constants.HIVE_PROFILE,
//                "Date": responseDetails.data,
//                "Authentication": responseDetails.hmac,
//            ],
//            completed: handleAddressHistoryResponse as (Result<[ShortOrderInfo], APError>) -> Void)
//    }
//    
//    private func handleAddressHistoryResponse<T: Decodable>(_ result: Result<T, APError>) {
//        DispatchQueue.main.async { [self] in
//            self.isLoading = false
//            
//            switch result {
//                case .success(let response):
//                    if let appetizers = response as? [ShortOrderInfo] {
//                        self.addressHistoryResponse = appetizers
//                    }
//                    
//                    
//                case .failure(let error):
//                    switch error {
//                        case .invalidURL:
//                            alertItem = AlertContext.invalidURL
//                        case .invalidResponse:
//                            alertItem = AlertContext.invalidResponse
//                        case .invalidData:
//                            alertItem = AlertContext.invalidData
//                        case .unableToComplete:
//                            alertItem = AlertContext.unableToComplete
//                    }
//            }
//        }
//    }
//    
    
}
