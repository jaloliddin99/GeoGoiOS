//
//  OrderGoViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/07/24.
//

import Foundation

final class OrderGoViewModel: ObservableObject{
    
    
    @Published var tariff: ServiceResponse?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    private var generateResponse: GenerateResponse?

    func initMain() {
        let url = UserDefaults.standard.string(forKey: Constants.clientApi)!
        let userId = UserDefaults.standard.integer(forKey: Constants.userLoginId)
        let userToken = UserDefaults.standard.string(forKey: Constants.userLoginKey)!
        
        generateResponse = GenerateResponse(userId: userId, userToken: userToken, mainUrl: url)
        
    }

  
}
