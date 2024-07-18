//
//  MainScreenViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import Foundation
import Combine
import SwiftUI
@_spi(Experimental) import MapboxMaps

final class MainViewModel: ObservableObject{
    
    @Published var isSearchDialogShowing = false
    
    @Published var isShowingMain = false
    @Published var status = DataHolder.status
    var hasOrderGoViewAppeared = false

    func setStatus(value: Int) {
        self.status = value
        DataHolder.status = value
        if value == 0 {
            hasOrderGoViewAppeared = false
        }
    }
    
    let tashkent = CLLocationCoordinate2D(latitude: 41.33851520919809, longitude: 69.33460926588599)
    init() {
        MapboxOptions.accessToken = "pk.eyJ1Ijoic2FkdWwiLCJhIjoiY2txNnQwY2VwMDN3MDJucGM0NDZ6YzNybSJ9.K1Pz4WVYeYY0eaqy1tbgWw"
        initMain()
    }
    
    
    private var generateResponse: GenerateResponse?
    
    func initMain() {
        let url = UserDefaults.standard.string(forKey: Constants.clientApi)!
        let userId = UserDefaults.standard.integer(forKey: Constants.userLoginId)
        let userToken = UserDefaults.standard.string(forKey: Constants.userLoginKey)!
        
        generateResponse = GenerateResponse(userId: userId, userToken: userToken, mainUrl: url)
        addressHistory()
    }
    
    
    
    @Published var currentAddress: UpdateReverseModel?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    func reverseLocation(lat: Double, lon: Double) {
        isLoading = true
        NetworkService.shared.sendRequest(
            url: UserDefaults().string(forKey: Constants.reverse)!+"reverse",
            params: ["format": Constants.FORMAT,
                     "lat": String(lat),
                     "lon": String(lon),
                     "addressdetails": "1",
                     "accept-language": "uz"
                    ],
            method: "GET",
            headers: ["Accept-Language": "uz"],
            isPrintable: true,
            completed: handleAppetizersResponse as (Result<UpdateReverseModel, APError>) -> Void)
    }
    
    private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let appetizers = response as? UpdateReverseModel {
                        self.currentAddress = appetizers
                        let name = currentAddress?.display_name ?? "Point on the map"
                        let lat = Double(currentAddress?.lat ?? "0") ?? 0.0
                        let lon = Double(currentAddress?.lon ?? "0") ?? 0.0
                        locationHolder.removeAll()
                        locationUpdated(UserSelectedAddress(addressName: name, addressLocation: LatLng(latitude: lat, longitude: lon)))
                        
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
    
    
    
    
    
    
    @Published var addressHistoryResponse: [ShortOrderInfo]?
    
    func addressHistory() {
        
        guard let responseDetails = generateResponse?.generateHmacData(id: Constants.HISTORY) else { return }
        
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            method: "GET",
            headers: [
                "Accept-Language": "uz",
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            completed: handleAddressHistoryResponse as (Result<[ShortOrderInfo], APError>) -> Void)
    }
    
    private func handleAddressHistoryResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let appetizers = response as? [ShortOrderInfo] {
                        self.addressHistoryResponse = appetizers
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
    
    
    @Published var tariff: ServiceResponse?
    
    func serviceTariffRequest() {
        guard let responseDetails = generateResponse?.generateHmacData(id: "getAvailableService") else { return }
        let body = PaymentMethodParent(prevServiceId: "", paymentMethod: Constants.paymentMethod)
        guard let requestBodyData = try? JSONEncoder().encode(body) else {
            print("Failed to encode request body")
            return
        }
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            body: requestBodyData,
            method: "POST",
            headers: [
                "Accept-Language": "uz",
                "Hive-Profile": Constants.HIVE_PROFILE,
                "X-Hive-GPS-Position": "\(Constants.latitude) \(Constants.longitude)",
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            completed: handleServiceTariffRequestResponse as (Result<ServiceResponse, APError>) -> Void)
    }
    
    private func handleServiceTariffRequestResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let response = response as? ServiceResponse {
                        self.tariff = response
                        DataHolder.serviceTariffConstant = response.tariffs
                        DataHolder.listOptions.removeAll()
                        DataHolder.listOptions.append(contentsOf: dataSelect(data: response.tariffs!))
                        response.tariffs?.forEach({ tariff in
                            let estimate = getEstimateRideRequest(
                                serviceTariff: tariff,
                                route: mapToRouteCoordinates(addresses: locationHolder))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.serviceEstimateRide(body: estimate)
                            }
                        })
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
    
    
    @Published var estimateResponse: EstimateResponse?
    
    func serviceEstimateRide(body: EstimateRideRequest) {
        guard let responseDetails = generateResponse?.generateHmacData(id: Constants.ESTIMATE) else { return }
        
        guard let requestBodyData = try? JSONEncoder().encode(body) else {
            print("Failed to encode request body")
            return
        }
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            body: requestBodyData,
            method: "POST",
            headers: [
                "Accept-Language": "uz",
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            completed: { [weak self] (result: Result<EstimateResponse, APError>) in
                self?.handleserviceEstimateRideRequestResponse(result, with: body)
            }
        )
    }
    
    private func handleserviceEstimateRideRequestResponse<T: Decodable>(_ result: Result<T, APError>, with body: EstimateRideRequest) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let response = response as? EstimateResponse {
                        self.estimateResponse = response
                        var tariffs = tariff?.tariffs
                        if tariffs != nil {
                            estimateResponse?.cost.type = String(body.tariff)
                            changeCost(res: estimateResponse!, list: &tariffs!)
                            tariff?.tariffs = tariffs
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
    
    
    @Published var routeCoordinates: [MyPoint]?
    
    func requestToDrawRoute() {
        let list: [String] = mapToRouteCoordinatesLatLng(coordinates: locationHolder)
        let params: [String: String] = [
            "locale": "uz",
            "calc_points": "true",
            "profile": "car"
        ]
        
        var queryString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                
        for point in list {
            queryString += "&point=\(point)"
        }
        
        let urlWithParams = Constants.NAVI_BASE_URL + "?" + queryString

        NetworkService.shared.sendRequest(
            url: urlWithParams,
            method: "GET",
            isPrintable: true,
            completed: handleDrawRouteRequestResponse as (Result<GraphopperNavResponse, APError>) -> Void)
    }
    
    private func handleDrawRouteRequestResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let response = response as? GraphopperNavResponse {
                        let locations = decode(encodedPath: response.paths[0].points, precision: 5)
                        routeCoordinates = locations
                        addLine(points: locations)
                    }
                    
                case .failure(_): break
                    
            }
        }
    }
    
    @Published var locationHolder: [UserSelectedAddress] = []
    
    func locationUpdated(_ address: UserSelectedAddress) {
        locationHolder.append(address)
        if status == 1 && locationHolder.count > 2{
            requestToDrawRoute()
        }
    }
    
    func retainFirstElement() {
        if locationHolder.count > 1 {
            locationHolder.removeSubrange(1..<locationHolder.count)
        }
    }
    
    
    
    
}
