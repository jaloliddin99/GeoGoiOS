//
//  EnterCodeViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 29/06/24.
//

import Foundation

final class EnterCodeViewModel: ObservableObject{
    
    @Published var response: ConfirmMessageResponse?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    func getAppetizer(id: String, code: String, phone: String) {
        isLoading = true
        
        if code == Constants.DEFAULT_CODE && phone == Constants.DEFAULT_PHONE_NUMBER {
            
            UserDefaults.standard.set(Constants.DEFAULT_ID, forKey: Constants.userLoginId)
            UserDefaults.standard.set(Constants.DEFAULT_KEY, forKey: Constants.userLoginKey)
            UserDefaults.standard.set(true, forKey: Constants.isUserLoggedIn)
            
            self.response = ConfirmMessageResponse(
                id: Int64(Constants.DEFAULT_ID),
                key: Constants.DEFAULT_KEY
            )
            return
        }
        NetworkService.shared.sendRequest(
            url: UserDefaults().string(forKey: Constants.baseUrl)!+"/api/client/mobile/1.0/registration/confirm",
            params: ["id": id, "code": code],
            method: "GET",
            headers: ["Accept-Language": "uz",
                      "Hive-Profile": Constants.HIVE_PROFILE
                     ],
            isPrintable: true,
            completed: handleAppetizersResponse as (Result<ConfirmMessageResponse, APError>) -> Void)
    }
    
    private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
            case .success(let response):
                if let confirmResponse = response as? ConfirmMessageResponse {
                    self.response = confirmResponse
                    
                    UserDefaults.standard.set(confirmResponse.id, forKey: Constants.userLoginId)
                    UserDefaults.standard.set(confirmResponse.key, forKey: Constants.userLoginKey)
                    UserDefaults.standard.set(true, forKey: Constants.isUserLoggedIn)
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
