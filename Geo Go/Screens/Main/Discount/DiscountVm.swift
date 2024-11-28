//
//  DiscountVm.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 29/08/24.
//

import Foundation


final class DiscountVm: ObservableObject {
    
    init() {
        initMain()
    }
    @Published var isShowingPopup = false
    @Published var isLoading = false

    private var generateResponse: GenerateResponse?
    
    func initMain() {
        let url = UserDefaults.standard.string(forKey: Constants.clientApi)!
        let userId = UserDefaults.standard.integer(forKey: Constants.userLoginId)
        let userToken = UserDefaults.standard.string(forKey: Constants.userLoginKey)!
        generateResponse = GenerateResponse(userId: userId, userToken: userToken, mainUrl: url)
    }
    
    @Published var alertItem: AlertItem?
    
    @Published var getPromoCodeResponse: ResponsePromoCode?
    
    func getPromoCodes() {
        isLoading = true
        let phone = UserDefaults.standard.string(forKey: Constants.USER_PHONE)?.replacing("+", with: "")
        guard let userPhone = phone else { return }
        NetworkService.shared.sendRequest(
            url: "\(Constants.NAVI2_URL)/promocode/\(userPhone)?page=1&size=25",
            method: "GET",
            completed: handleGetPromoCodesResponse as (Result<ResponsePromoCode, APError>) -> Void)
    }
    
    private func handleGetPromoCodesResponse<T: Decodable>(_ result: Result<T, APError>) {
        isLoading = false
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let appetizers = response as? ResponsePromoCode {
                        self.getPromoCodeResponse = appetizers
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
    
    
    
    @Published var getDiscountsResponse:  [NewsData]?

    func getDiscounts() {
        let url = UserDefaults.standard.string(forKey: Constants.clientNews)!.replacing("news", with: "discount")

        NetworkService.shared.sendRequest(
            url: url,
            method: "GET",
            isPrintable: true,
            completed: handleGetDiscountResponse as (Result<ResponseNews, APError>) -> Void)
    }
    
    private func handleGetDiscountResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let appetizers = response as? ResponseNews {
                        self.getDiscountsResponse = appetizers.data
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

    
    
    
    @Published var postPromoCodeResponse: PromoCodeResponse?

    func postPromoCode(body: PromoCodeSend) {
        
        guard let responseDetails = generateResponse?.generateHmacData(id: Constants.ACTIVATIONS) else { return }
        guard let requestBodyData = try? JSONEncoder().encode(body) else {
            print("Failed to encode request body")
            return
        }
        
        isLoading = true

        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            body: requestBodyData,
            method: "POST",
            headers: [
                "Accept-Language": DataHolder.lang,
                "Hive-Profile": Constants.HIVE_PROFILE,
                "X-Hive-GPS-Position": "\(DataHolder.location.latitude) \(DataHolder.location.longitude)",
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            isPrintable: true,
            completed: handlePostPromoCodeResponse as (Result<PromoCodeResponse, APError>) -> Void)
    }
    
    private func handlePostPromoCodeResponse<T: Decodable>(_ result: Result<T, APError>) {
        isLoading = false

        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let appetizers = response as? PromoCodeResponse {
                        self.postPromoCodeResponse = appetizers
                        let userPhone = UserDefaults.standard.string(forKey: Constants.USER_PHONE)!
                        postPromocodeToSecondServer(body: RequestPromoCode(
                            date: getCurrentDate(),
                                   phone: userPhone,
                                   promocode_amount: Int(appetizers.amount),
                                   promocode_name: " "
                                  )
                        )
                        print("Hello Success....")
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
    
    @Published var ppr: PostPromoCodeResponse?

    
    
    func postPromocodeToSecondServer(body: RequestPromoCode) {
        
        guard let requestBodyData = try? JSONEncoder().encode(body) else {
            print("Failed to encode request body")
            return
        }
        
        if let jsonString = String(data: requestBodyData, encoding: .utf8) {
            print("Create body: \(jsonString)")
        }
        isLoading = true
        
        NetworkService.shared.sendRequest(
            url: "\(Constants.NAVI2_URL)/promocode/",
            body: requestBodyData,
            method: "POST",
            isPrintable: true,
            completed: handlePPRResponse as (Result<PostPromoCodeResponse, APError>) -> Void)
    }
    
    private func handlePPRResponse<T: Decodable>(_ result: Result<T, APError>) {
        isLoading = false
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let appetizers = response as? PostPromoCodeResponse {
                        self.ppr = appetizers
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
    
   
    
    
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = Date()
        return dateFormatter.string(from: date)
    }

    
    
}
