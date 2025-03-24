//
//  AccessViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import Foundation
import UIKit
import SwiftUI



final class AccessViewModel: ObservableObject {
    
    
    @Published var postData: GetServerLinks?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?


    
    func getAppetizer(lat: Double, lon: Double) {
           isLoading = true
           NetworkService.shared.sendRequest(
            path: "\(lat)/\(lon)",
            isPrintable: true,
            completed: handleAppetizersResponse as (Result<GetServerLinks, APError>) -> Void)
       }
       
       private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
           DispatchQueue.main.async { [self] in
               self.isLoading = false
               
               switch result {
               case .success(let response):
                   if let appetizers = response as? GetServerLinks {
                       saveDataIntoPersistence(data: appetizers.data)
                       self.postData = appetizers
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
        UserDefaults.standard.set("\(data.client_url):443/api", forKey: Constants.clientApi)
        UserDefaults.standard.set(data.url, forKey: Constants.baseUrl)
        UserDefaults.standard.set(data.driver_reg, forKey: Constants.deptId)
        UserDefaults.standard.set(data.reg_num_mask, forKey: Constants.driverMask)
        UserDefaults.standard.set(data.sign, forKey: Constants.sign)
        UserDefaults.standard.set(data.navi, forKey: Constants.naviUrl)
        UserDefaults.standard.set(data.country, forKey: Constants.residence)
        UserDefaults.standard.set(data.socket, forKey: Constants.driverSocket)
        UserDefaults.standard.set(data.client_lan, forKey: Constants.clientLan)
        LanguageViewModel.shared.changeLanguage(to: data.client_lan)
        UserDefaults.standard.set(data.client_info, forKey: Constants.clientInfo)
        UserDefaults.standard.set(data.client_news, forKey: Constants.clientNews)
        UserDefaults.standard.set(data.reverse, forKey: Constants.reverse)
        UserDefaults.standard.set(data.user_url, forKey: Constants.userUrl)
        UserDefaults.standard.set(data.chat_url, forKey: Constants.chatUrl)
        UserDefaults.standard.set(data.client_api_socket, forKey: Constants.clientApiSocket)
        UserDefaults.standard.set(data.client_body, forKey: Constants.clientBody)
        UserDefaults.standard.set(data.driver_body, forKey: Constants.driverBody)
        UserDefaults.standard.set(data.route, forKey: Constants.route)
        UserDefaults.standard.set(data.search, forKey: Constants.search)
    }
    
    
}

