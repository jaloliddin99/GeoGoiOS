//
//  ViewModelAddCard.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/09/24.
//

import Foundation
import SwiftUI

final class ViewModelAddCard: ObservableObject {
    
    
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    
    @Published var addCardResponse: ModelAddCardResponse?
    
    func addCardRequest(body: ModelAddCard) {
        guard let requestBodyData = try? JSONEncoder().encode(body) else {
            print("Failed to encode request body")
            return
        }
        isLoading = true
        NetworkService.shared.sendRequest(
            url: "\(Constants.ATMOS_BASE_URL)card/init",
            body: requestBodyData,
            method: "POST",
            isPrintable: true,
            completed: { [weak self] (result: Result<ModelAddCardResponse, APError>) in
                self?.handleAddCardResponseBody(result)
            }
        )
    }
    
    private func handleAddCardResponseBody<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let response = response as? ModelAddCardResponse {
                        if response.success {
                            self.addCardResponse = response
                        }else {
                            alertItem = AlertItem(title: Text("alert_title_server_error"),
                                                  message: Text(response.error ?? ""),
                                                  dismissButton: .default(Text("OK")))
                        }
                    
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
    
    
    
    @Published var confirmCardResponse: ModelConfirmCardResponse?
    
    func confirmCardRequest(body: ModelConfirmCard) {
        guard let requestBodyData = try? JSONEncoder().encode(body) else {
            print("Failed to encode request body")
            return
        }
        isLoading = true
        NetworkService.shared.sendRequest(
            url: "\(Constants.ATMOS_BASE_URL)card/confirm",
            body: requestBodyData,
            method: "POST",
            isPrintable: true,
            completed: { [weak self] (result: Result<ModelConfirmCardResponse, APError>) in
                self?.handleConfirmCardResponseBody(result)
            }
        )
    }
    
    private func handleConfirmCardResponseBody<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let response = response as? ModelConfirmCardResponse {
                        if response.success {
                            self.confirmCardResponse = response
                        }else {
                            alertItem = AlertItem(title: Text("alert_title_server_error"),
                                                  message: Text(response.error ?? ""),
                                                  dismissButton: .default(Text("OK")))
                        }
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
    
    
    
    @Published var getAllCardResponse: [CardData]?
    
    func getAllCardsRequest() {
        
        isLoading = true
        NetworkService.shared.sendRequest(
            url: "\(Constants.ATMOS_BASE_URL)card/user/\(getUserPhone())",
            method: "GET",
            isPrintable: true,
            completed: { [weak self] (result: Result<ModelGetCards, APError>) in
                self?.handleAllCardsResponseBody(result)
            }
        )
    }
    
    private func handleAllCardsResponseBody<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let response = response as? ModelGetCards {
                        self.getAllCardResponse = response.data
                        if let list = response.data {
                            if list.isEmpty {
                                setPaymentMethod(method: Constants.PAYMENT_TYPE_CASH)
                            }
                        }
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
    
    
    @Published var setCardAsMainResponse: ModelConfirmCardResponse?
    
    func setAsMainRequest(cardId: Int) {
        let body = ModelUpdateCardAsMain(is_main: true, userId: getUserPhone())
        guard let requestBodyData = try? JSONEncoder().encode(body) else {
            print("Failed to encode request body")
            return
        }
        isLoading = true
        NetworkService.shared.sendRequest(
            url: "\(Constants.ATMOS_BASE_URL)card/\(cardId)",
            body: requestBodyData,
            method: "PUT",
            isPrintable: true,
            completed: { [weak self] (result: Result<ModelConfirmCardResponse, APError>) in
                self?.handleSetAsMainResponseBody(result)
            }
        )
    }
    
    private func handleSetAsMainResponseBody<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let response = response as? ModelConfirmCardResponse {
                        if response.success {
                            self.setCardAsMainResponse = response
                            getAllCardsRequest()
                        }else {
                            alertItem = AlertItem(title: Text("alert_title_server_error"),
                                                  message: Text(response.error ?? ""),
                                                  dismissButton: .default(Text("OK")))
                        }
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
