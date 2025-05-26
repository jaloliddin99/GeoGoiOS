//
//  EnterPhoneViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 28/06/24.
//

import Foundation

final class EnterPhoneViewModel : ObservableObject{
    @Published var postData: RegisterUserResponse?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    func submitRegistration(regRequest: RegistrationRequest) {
        guard let requestBodyData = try? JSONEncoder().encode(regRequest) else {return}
        isLoading = true
        UserDefaults.standard.setValue(regRequest.info.firstName, forKey: Constants.USER_NAME)
        
        if regRequest.phone == Constants.DEFAULT_PHONE_NUMBER {
            self.isLoading = false
            if let testLinks = loadServerLinksFromFile() {
                saveDataIntoPersistence(data: testLinks.data)
            }
            self.postData = RegisterUserResponse(id: 1)
            return
        }
            

        NetworkService.shared.sendRequest(
            url: UserDefaults().string(forKey: Constants.clientApi)!+"/client/mobile/1.0/registration/submit",
            body: requestBodyData,
            method: "POST",
            headers: ["Accept-Language": DataHolder.lang,
                      "Hive-Profile": Constants.HIVE_PROFILE
                     ],
            isPrintable: true,
            completed: handleAppetizersResponse as (Result<RegisterUserResponse, APError>) -> Void)
    }
    
    func loadServerLinksFromFile() -> GetServerLinks? {
        guard let url = Bundle.main.url(forResource: "server_links", withExtension: "json") else {
            print("📛 Could not find file")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(GetServerLinks.self, from: data)
            return result
        } catch {
            print("📛 Failed to decode JSON: \(error)")
            return nil
        }
    }

    
    private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            switch result {
            case .success(let response):
                if let appetizers = response as? RegisterUserResponse {
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
}
