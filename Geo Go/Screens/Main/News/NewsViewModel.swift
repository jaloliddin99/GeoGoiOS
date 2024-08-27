//
//  NewsViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/08/24.
//

import Foundation

final class NewsViewModel : ObservableObject {
    
    
    @Published var news: [NewsData]?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    init() {
        getAllNews()
    }
    
    func getAllNews() {
        let url = UserDefaults.standard.string(forKey: Constants.clientNews)!
        NetworkService.shared.sendRequest(
            url: url,
            params: ["lan": DataHolder.lang],
            method: "GET",
            isPrintable: true,
            completed: handleNewsResponse as (Result<ResponseNews, APError>) -> Void)
    }
    
    private func handleNewsResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let news = response as? ResponseNews{
                        self.news = news.data
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
