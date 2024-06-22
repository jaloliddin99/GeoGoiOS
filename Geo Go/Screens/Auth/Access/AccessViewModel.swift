//
//  AccessViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import Foundation



final class AccessViewModel: ObservableObject {
    
    
    @Published var postData: GetServerLinks?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?


    
    func getAppetizer(lat: Double, lon: Double) {
           isLoading = true
           NetworkService.shared.sendRequest(
            path: "\(lat)/\(lon)",
            completed: handleAppetizersResponse as (Result<GetServerLinks, APError>) -> Void)
       }
       
       private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
           DispatchQueue.main.async { [self] in
               self.isLoading = false
               
               switch result {
               case .success(let response):
                   if let appetizers = response as? GetServerLinks {
                       self.postData = appetizers
                       saveDataIntoPersistence(data: appetizers.data)
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
    
    private func saveDataIntoPersistence(data: LinkData){
        UserDefaults.standard.set(data.driver_call_center, forKey: Constants.driverCallCenter)
        UserDefaults.standard.set("\(data.url):3443/api/", forKey: Constants.driverApi)
        UserDefaults.standard.set(data.url, forKey: Constants.baseUrl)
        UserDefaults.standard.set(data.driver_reg, forKey: Constants.deptId)
        UserDefaults.standard.set(data.reg_num_mask, forKey: Constants.driverMask)
        UserDefaults.standard.set(data.sign, forKey: Constants.sign)
        UserDefaults.standard.set(data.navi, forKey: Constants.naviUrl)
        UserDefaults.standard.set(data.country, forKey: Constants.residence)
        UserDefaults.standard.set(data.socket, forKey: Constants.driverSocket)

    }
    
    
   }
