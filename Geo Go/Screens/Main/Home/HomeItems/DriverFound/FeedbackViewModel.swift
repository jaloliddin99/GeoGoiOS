//
//  FeedbackViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/08/24.
//

import SwiftUI

final class FeedbackViewModel: ObservableObject {
    
    @Published var feedback: [CancelOptionData]?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    @Published var selectedOptionID: String? = nil

    func getFeedbacks() {
        isLoading = true
        NetworkService.shared.sendRequest(
            url: UserDefaults().string(forKey: Constants.chatUrl)!+"/api/v1/feedback-status",
            params: ["lan": "uz"],
            method: "GET",
            completed: handleCancelOptions as (Result<CancelOrderOptionsModel, APError>) -> Void)
    }
    
    private func handleCancelOptions<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            switch result {
                case .success(let response):
                    if let appetizers = response as? CancelOrderOptionsModel {
                        self.feedback = appetizers.data
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
    
    
    
    @Published var feedbackResponse: ResponseFeedback?

    func postFeedBacks(feedBackBody: FeedBackPostModel) {
        isLoading = true
        
        guard let requestBodyData = try? JSONEncoder().encode(feedBackBody) else {
            print("Failed to encode request body")
            return
        }
        
        NetworkService.shared.sendRequest(
            url: UserDefaults().string(forKey: Constants.chatUrl)!+"/api/v1/complains",
            body: requestBodyData,
            method: "POST",
            isPrintable: true,
            completed: handleCancelOptionsResponse as (Result<ResponseFeedback, APError>) -> Void)
        
    }
    
    private func handleCancelOptionsResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            switch result {
                case .success(let response):
                    if let appetizers = response as? ResponseFeedback {
                        self.feedbackResponse = appetizers
                        
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


