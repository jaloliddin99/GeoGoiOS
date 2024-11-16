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
    @Published var isShowBonusDialog = false
    @Published var isShowingMain = false
    @Published var status = DataHolder.status
    @Published var showCancelOrderAlert = false
    @Published var showCancelBottomDialog = false
    @Published var bottomSheetShown = false
    @Published var showRateDriver = false
    @Published var showBonusDialog = false
    @Published var showTariffDetailsDialog = false
    @Published var location: CLLocationCoordinate2D = DataHolder.location
    @Published var selectedLocation: CLLocationCoordinate2D = DataHolder.location
    @Published var refocusButtonListener = false
    
    @Published var discountModel: DiscountModel?
    var hasOrderGoViewAppeared = false
    
    func setStatus(value: Int) {
        self.status = value
        DataHolder.status = value
        if value == 0 {
            hasOrderGoViewAppeared = false
        }
    }
    
    init() {
        MapboxOptions.accessToken = "pk.eyJ1IjoiZ2VvZ29hcHAiLCJhIjoiY2xnaHJleWNyMGRvczNkbGY2Ym41eHY3NyJ9.xI3D0Q4YyqNxCl8j1c7kZg"
        initMain()
    }
    
    
    private var generateResponse: GenerateResponse?
    
    func initMain() {
        let url = UserDefaults.standard.string(forKey: Constants.clientApi)!
        let userId = UserDefaults.standard.integer(forKey: Constants.userLoginId)
        let userToken = UserDefaults.standard.string(forKey: Constants.userLoginKey)!
        
        generateResponse = GenerateResponse(userId: userId, userToken: userToken, mainUrl: url)
        addressHistory()
        getBonusResponse(lat: DataHolder.location.latitude, lon: DataHolder.location.longitude)
        getClientOrders()
    }
    
    func findUserRealPosition(loc: CLLocationCoordinate2D, offset: CGFloat) {
        location = location
        refocusButtonListener.toggle()
        reverseGeocodeIfNeeded(offset: offset)
    }
    
    
    func reverseGeocodeIfNeeded(offset: CGFloat) {
        if offset == 0 && status == 0 {
            reverseLocation(lat: selectedLocation.latitude, lon: selectedLocation.longitude)
        }
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
                     "accept-language": DataHolder.lang
                    ],
            method: "GET",
            headers: ["Accept-Language": "uz"],
            completed: handleAppetizersResponse as (Result<UpdateReverseModel, APError>) -> Void)
    }
    
    private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let appetizers = response as? UpdateReverseModel {
                        self.currentAddress = appetizers
                        
                        let name = appetizers.display_name ?? "Point on the map"
                        let lat = Double(appetizers.lat) ?? 0.0
                        let lon = Double(appetizers.lon) ?? 0.0
                        locationHolder.removeAll()
                        locationUpdated(UserSelectedAddress(addressName: name, addressLocation: CLLocationCoordinate2D(latitude: lat, longitude: lon)))
                        
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
                "Accept-Language": DataHolder.lang,
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
    
    
    @Published var dateOrderHistory: DateOrderHistory?
    
    func dateOrderHistory(id: Int64, location: CLLocationCoordinate2D) {
        guard let responseDetails = generateResponse?.generateHmacDataForOrderId(id: Constants.FINISHED, orderId: id) else { return }
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            method: "GET",
            headers: [
                "Accept-Language": DataHolder.lang,
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
                "X-Hive-GPS-Position": "\(location.latitude) \(location.longitude)",
            ],
            isPrintable: true,
            completed: { [weak self] (result: Result<DateOrderHistory, APError>) in
                self?.handleDateOrderHistoryResponse(result, with: id)
            }
        )
    }
    
    private var counter = 0
    
    private func handleDateOrderHistoryResponse<T: Decodable>(_ result: Result<T, APError>, with body: Int64) {
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let response = response as? DateOrderHistory {
                        counter = counter + 1
                        print("Counter number \(counter)")
                        self.dateOrderHistory = response
                        var shortOrderInfo = self.addressHistoryResponse
                        if shortOrderInfo != nil {
                            setShortOrderInfoProperties(res: dateOrderHistory!, list: &shortOrderInfo!, orderId: body)
                            self.addressHistoryResponse = shortOrderInfo
                        }
                    }
                case .failure(_): break
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
                "Accept-Language": DataHolder.lang,
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
                "Accept-Language": DataHolder.lang,
                "Hive-Profile": Constants.HIVE_PROFILE,
                "X-Hive-GPS-Position": "\(location.latitude) \(location.longitude)",
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
                        
                        self.discountModel = optionBonus(serviceResponse: tariff!, lang: DataHolder.lang)
                        DataHolder.serviceTariffConstant = response.tariffs
                        DataHolder.tariffId = response.tariffs![0].id
                        DataHolder.selectedTariff = response.tariffs![0]
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

    
    
    @Published var routeCoordinates: [MyPoint]?
    
    func requestToDrawRoute(list: [String]) {
        let params: [String: String] = [
            "locale": DataHolder.lang,
            "calc_points": "true",
            "profile": "car"
        ]
        
        var queryString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        
        for point in list {
            queryString += "&point=\(point)"
        }
        
        let urlWithParams = Constants.NAVI_BASE_URL + "&" + queryString
        
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
    
    
    
    
    @Published var bonusResponse: BonusResponse = BonusResponse(balance: 0, capabilities: Capabilities(type: "min-max", min: 0, max: 0))
    
    func getBonusResponse(lat: Double, lon: Double) {
        guard let responseDetails = generateResponse?.generateHmacData(id: "bonuses") else { return }
        
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            method: "GET",
            headers: [
                "X-Hive-GPS-Position": "\(lat) \(lon)",
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            completed: handleBonusResponse as (Result<BonusResponse, APError>) -> Void)
    }
    
    private func handleBonusResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let appetizers = response as? BonusResponse {
                        self.bonusResponse = appetizers
                    }
                    
                case .failure(_): break
            }
        }
    }
    
    
    
    
    @Published var createOrder: CreateOrderResponse?
    
    func createOrder(lat: Double, lon: Double, createOrderRequest: CreateOrderRequest) {
        guard let responseDetails = generateResponse?.generateHmacData(id: "orders") else { return }
        
        guard let requestBodyData = try? JSONEncoder().encode(createOrderRequest) else {
            return
        }
        if let jsonString = String(data: requestBodyData, encoding: .utf8) {
            print("Create body: \(jsonString)")
        }
        
        self.isLoading = true
        isShowBonusDialog.toggle()
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            body: requestBodyData,
            method: "POST",
            headers: [
                "Accept-Language": DataHolder.lang,
                "X-Hive-GPS-Position": "\(lat) \(lon)",
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            completed: handlecreateOrderResponse as (Result<CreateOrderResponse, APError>) -> Void)
    }
    
    private func handlecreateOrderResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let appetizers = response as? CreateOrderResponse {
                        innerOrderInfoState = status
                        status = 2
                        self.createOrder = appetizers
                        DataHolder.status = status
                        DataHolder.orderId = appetizers.id
                        startTimer(orderId: appetizers.id)
                        
                    }
                case .failure(_): break
            }
        }
    }
    
    
    @Published var cancelOrder: EmptyModel?
    
    func cancelMyOrder() {
        guard let responseDetails = generateResponse?.generateHmacDataForOrderId(id: "cancelOrder", orderId: DataHolder.orderId) else { return }
        
        if status >= 2 {
            showCancelBottomDialog.toggle()
        }
        self.isLoading = true
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            method: "DELETE",
            headers: [
                "Accept-Language": DataHolder.lang,
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            isPrintable: true,
            completed: handleCancelOrderResponse as (Result<EmptyModel, APError>) -> Void)
    }
    
    private func handleCancelOrderResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let appetizers = response as? EmptyModel {
                        self.cancelOrder = appetizers
                        status = 1
                        DataHolder.status = status
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
        
    func getClientOrders() {
        guard let responseDetails = generateResponse?.generateHmacData(id: Constants.ORDERS_GET) else { return }
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            method: "GET",
            headers: [
                "Accept-Language": DataHolder.lang,
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            completed: handleClientOrdersResponse as (Result<[ShortOrderInfo], APError>) -> Void)
    }
    
    private func handleClientOrdersResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let res = response as? [ShortOrderInfo] {
                        filterClientOrders(res: res)
                    }
                case .failure(_): break
            }
        }
    }
    
    private func filterClientOrders(res: [ShortOrderInfo]) {
        if let highestStateOrder = res.max(by: { $0.state < $1.state }) {
            startTimer(orderId: highestStateOrder.id)
            DataHolder.orderId = highestStateOrder.id
        }
    }
    
    
    @Published var getOrderDetail: OrderInfo?
    
    private func getOrderDetails(orderId: Int64) {
        guard let responseDetails = generateResponse?.generateHmacDataForOrderId(id: Constants.GET_ORDER_DETAILS, orderId: orderId) else { return }
        
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            method: "GET",
            headers: [
                "Accept-Language": DataHolder.lang,
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ],
            isPrintable: true,
            completed: handleOrderInfoResponse as (Result<OrderInfo, APError>) -> Void)
    }
    
    private func handleOrderInfoResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let res = response as? OrderInfo {
                        getOrderDetail = res
                        handleUIByOrderStatus(orderInfo: res)
                    }
                case .failure(_): break
            }
        }
    }
    
    private var innerOrderInfoState: Int = -1
    private func handleUIByOrderStatus(orderInfo: OrderInfo) {
        guard innerOrderInfoState != orderInfo.state else { return }
        innerOrderInfoState = orderInfo.state
        
        switch orderInfo.state {
            case 1:
                status = 2
                
            case 2:
                status = 3
                let coordinates = getCoorWithDriverLoc(orderInfo: orderInfo)
                requestToDrawRoute(list: coordinates)
                
            case 3:
                status = 4
                
            case 4:
                let routeCoordinates = mapToRouteCoordinatesLatLng(coordinates: locationHolder)
                requestToDrawRoute(list: routeCoordinates)
                status = 5
                
            case 5:
                stopTimer()
                showRateDriver.toggle()
                status = 0
                
            case 6:
                stopTimer()
                status = 0
                
            default:
                print("Unexpected order state: \(orderInfo.state)")
        }
        DataHolder.status = status
    }

    
    @Published var image: Image? = nil
    
    func loadImage(fromURLString urlString: String) {
        NetworkService.shared.downloadImage(fromURLString: urlString) { uiImage in
            guard let uiImage else { return }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
    
    
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    func startTimer(orderId: Int64) {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.getOrderDetails(orderId: orderId)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @Published var locationHolder: [UserSelectedAddress] = []
    
    func locationUpdated(_ address: UserSelectedAddress) {
        locationHolder.append(address)
        if status == 1 && locationHolder.count > 2 {
            requestToDrawRoute(list: mapToRouteCoordinatesLatLng(coordinates: locationHolder))
        }
    }
    
    func retainFirstElement() {
        if locationHolder.count > 1 {
            locationHolder.removeSubrange(1..<locationHolder.count)
        }
    }

    
    deinit {
        stopTimer()
    }
}
