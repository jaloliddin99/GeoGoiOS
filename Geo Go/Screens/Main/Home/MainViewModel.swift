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
import SocketIO

final class MainViewModel: ObservableObject{
    @Published var isDrawerOpen = false

    @Published var markerOffset: CGFloat = 0
    @Published var isSearchDialogShowing = false
    @Published var isShowBonusDialog = false
    @Published var isShowingMain = false
    @Published var showCancelOrderAlert = false
    @Published var showCancelBottomDialog = false
    @Published var bottomSheetShown = false
    @Published var showRateDriver = false
    @Published var showBonusDialog = false
    @Published var showTariffDetailsDialog = false
    @Published var location: CLLocationCoordinate2D = DataHolder.location
    @Published var selectedLocation: CLLocationCoordinate2D = DataHolder.location
    @Published var refocusButtonListener = false
    @Published var orderGoViewHeight: CGFloat = 250
    @Published var discountModel: DiscountModel?
    var isSetLocations = false
    @Published var status: Int = DataHolder.status {
        didSet {
            DataHolder.status = status
            if status == 1 {
                serviceTariffRequest()
                if locationHolder.count > 1 {
                    requestToDrawRoute(list: mapToRouteCoordinatesLatLng( locationHolder))
                }
            }
        }
    }

    func setStatus(value: Int) {
        DataHolder.status = value
        status = value
    }
    
    init() {
        MapboxOptions.accessToken = "pk.eyJ1IjoiZ2VvZ29hcHAiLCJhIjoiY2xnaHJleWNyMGRvczNkbGY2Ym41eHY3NyJ9.xI3D0Q4YyqNxCl8j1c7kZg"
        initMain()
        setupSocket()
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
    
    func findUserRealPosition(loc: CLLocationCoordinate2D) {
        location = loc
        refocusButtonListener.toggle()
        reverseGeocodeIfNeeded()
    }
    
    
    func reverseGeocodeIfNeeded() {
        if (markerOffset == 0 && status == 0) || (markerOffset == 0 && status == 1) {
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
            headers: ["Accept-Language": DataHolder.lang],
            completed: handleAppetizersResponse as (Result<UpdateReverseModel, APError>) -> Void)
    }
    
    private func handleAppetizersResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let appetizers = response as? UpdateReverseModel {
                        self.currentAddress = appetizers
                        
                        
                        let house = appetizers.address.house_number
                        let road = appetizers.address.road
                        let name = appetizers.name
                        let neighbourhood = appetizers.address.neighbourhood
                        let village = appetizers.address.village
                        let state = appetizers.address.state
                        let town = appetizers.address.town

                        let addressName = searchAddress(
                            DataHolder.lang, name, house, road,
                            neighbourhood, village, state, town
                        )
                        
                        let lat = Double(appetizers.lat) ?? 0.0
                        let lon = Double(appetizers.lon) ?? 0.0
                        let loc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        let model = UserSelectedAddress(addressName: addressName, addressLocation: loc)
                        if status == 0 {
                            locationHolder.removeAll()
                            locationUpdated(model)
                        }else if status == 1 {
                            locationUpdated(model, true, 0)
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
            completed: { [weak self] (result: Result<DateOrderHistory, APError>) in
                self?.handleDateOrderHistoryResponse(result, with: id)
            }
        )
    }
        
    private func handleDateOrderHistoryResponse<T: Decodable>(_ result: Result<T, APError>, with body: Int64) {
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let response = response as? DateOrderHistory {
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
    
    
    func getNearDrivers(tariffId: Int64){
        guard let responseDetails = generateResponse?.generateHmacData(id: "drivers") else { return }
        
        let paymentMethod: [String: Any] = [
            "kind": "cash"
        ]
        let body: [String: Any] = [
            "paymentMethod": paymentMethod,
            "tariff": tariffId
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return
        }
        
        
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            body: jsonData,
            method: "POST",
            headers: [
                "Accept-Language": DataHolder.lang,
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
                "X-Hive-GPS-Position": "\(location.latitude) \(location.longitude)",
            ],
            isPrintable: true,
            completed: { [weak self] (result: Result<[NDriver], APError>) in
                self?.handleNearDriversResponse(result, with: tariffId)
            }
       )
    }
        
    private func handleNearDriversResponse<T:Decodable>(_ result: Result<T,APError>, with tariffId: Int64) {
        DispatchQueue.main.async {
            switch result {
                case .success(let response):
                    if let res = response as? [NDriver] {
                        var tariffs = self.tariff?.tariffs
                        if tariffs != nil {
                            changeDistance(response: res, tariffId: tariffId, list: &tariffs!, clientLocation: self.location)
                            self.tariff?.tariffs = tariffs
                        }
                    }
                    
                case .failure(_): break
                    
            }
        }
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
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                self.serviceEstimateRide(body: estimate)
                                self.getNearDrivers(tariffId: tariff.id)
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
            completed: handleDrawRouteRequestResponse as (Result<GraphopperNavResponse, APError>) -> Void)
    }
    
    private func handleDrawRouteRequestResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            switch result {
                case .success(let response):
                    if let response = response as? GraphopperNavResponse {
                        let locations = decode(encodedPath: response.paths[0].points, precision: 5)
                        addLine(points: locations)
                        routeCoordinates = locations

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
                        DataHolder.status = status
                        status = 2
                        self.createOrder = appetizers
                        DataHolder.orderId = appetizers.id
                        getOrderDetails(orderId: appetizers.id)
                    }
                case .failure(_): break
            }
        }
    }
    
    
    @Published var cancelOrder: EmptyModel?
    
    func cancelMyOrder() {
        guard let responseDetails = generateResponse?.generateHmacDataForOrderId(id: "cancelOrder", orderId: DataHolder.orderId) else { return }
        
        if status > 2 {
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
            completed: handleCancelOrderResponse as (Result<EmptyModel, APError>) -> Void)
    }
    
    private func handleCancelOrderResponse<T: Decodable>(_ result: Result<T, APError>) {
        DispatchQueue.main.async { [self] in
            self.isLoading = false
            
            switch result {
                case .success(let response):
                    if let appetizers = response as? EmptyModel {
                        self.cancelOrder = appetizers
                        DataHolder.status = status
                        status = 1
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
            isPrintable: true,
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
        if let order = res.max(by: { $0.state < $1.state }) {
            DataHolder.orderId = order.id
            getOrderDetails(orderId: order.id)
        }
    }

    
    @Published var getOrderDetail: OrderInfo?
    
    func getOrderDetails(orderId: Int64, _ stopLoop: Bool = false) {
        guard let responseDetails = generateResponse?.generateHmacDataForOrderId(id: Constants.GET_ORDER_DETAILS, orderId: orderId) else { return }
        
        NetworkService.shared.sendRequest(
            url: responseDetails.url,
            method: "GET",
            headers: [
                "Accept-Language": DataHolder.lang,
                "Hive-Profile": Constants.HIVE_PROFILE,
                "Date": responseDetails.data,
                "Authentication": responseDetails.hmac,
            ]
        ) { [self] (result: Result<OrderInfo, APError>) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let res):
                        self.getOrderDetail = res
                        
                        if !stopLoop {
                            self.handleUIByOrderStatus(res.state)
                            self.configureSocketListeners(orderId: DataHolder.orderId)
                            
                            if let carNum = res.assignee?.car.regNum {
                                UserDefaults.standard.setValue(carNum, forKey: Constants.DRIVER_CAR_NUM)
                            }
                        }
                        
                        
                    case .failure(_):
                        break
                }
            }
        }
    }

    
    
    //socket
    
    @Published var sOrderInfo: SOrderInfo?
    @Published var sDriverRealTimeData: SDriverRealTimeData?
    @Published var sDriverLists: [SDriverData] = []
    
    private var socketManager: SocketManager!
    var socket: SocketIOClient!
    
    private func setupSocket() {
        socketManager = SocketManager(
            socketURL: URL(string: "http://185.224.219.1:3007")!,
            config: [
                .log(false),
                .compress,
                .connectParams(["EIO": "2"]),
                .forceWebsockets(true),
                .reconnects(true)
            ]
        )
        socket = socketManager.defaultSocket
        socket.on(clientEvent: .connect) { _, _ in
            self.setupInitialListeners()
        }
        connect()
    }
    
    func sendUserLocation(){
        let message = Message(
            lat: DataHolder.location.latitude,
            long: DataHolder.location.longitude,
            userId: getUserPhone(),
            type: "all"
        )
        
        if let messageData = message.toDictionary() {
            socket.emit("user", messageData)
        }
    }
    
    func connect() {
        guard socket.status != .connected else {
            return
        }
        socket.connect()
    }
    
    func disconnect() {
        guard socket.status != .disconnected else { return }
        socket.disconnect()
        socket.removeAllHandlers()
    }
    
    deinit {
        disconnect()
    }
    
    private var statusHolder: Int = -1
    func sendUserOrderIdAndLocs(orderId: Int64){
        let message = ModelSend(
            orderId: orderId,
            departureLocation: [DataHolder.location.latitude, DataHolder.location.longitude]
        )
        
        if let messageData = message.toDictionary() {
            
            socket.off("listen-order")
            socket.emit("listen-order", messageData)
            
            socket.on("listen-order") { [weak self] data, ack in
                guard let self = self else { return }
                if let orderInfo: SOrderInfo = parseSocketData(data: data, type: SOrderInfo.self) {
                    if statusHolder == orderInfo.orderStatus { return }
                    
                    statusHolder = orderInfo.orderStatus
                    if orderInfo.orderStatus == 5 {
                        getOrderDetails(orderId: orderId, true)
                    }
                    if orderInfo.orderStatus == 7 {
                        setDefaults()
                    }
                    handleUIByOrderStatus(orderInfo.orderStatus)
                    
                    if orderInfo.orderStatus == 2 {
                        getOrderDetails(orderId: DataHolder.orderId)
                        listenAttachedDriverLocation()
                    }
                    DispatchQueue.main.async {
                        self.sOrderInfo = orderInfo
                    }
                }
            }
        }
    }
    
    private func configureSocketListeners(orderId: Int64) {
        sendUserOrderIdAndLocs(orderId: orderId)
        turnOffCars()
    }
    
    private func turnOffCars(){
        socket.off("getCars")
    }
    
    private func setupInitialListeners() {
        turnOffCars()
        sendUserLocation()
        attachGetCars()
        
        if getOrderDetail != nil {
            sendUserOrderIdAndLocs(orderId: DataHolder.orderId)
        }
    }
    
    private func attachGetCars(){
        if status != 0 {
            return
        }
        socket.on("getCars"){ data, ack in
            if let cars: [SDriverData] = parseSocketData(data: data, type: [SDriverData].self) {
                DispatchQueue.main.async {
                    self.sDriverLists = cars
                }
            }
        }
    }
    
    func listenAttachedDriverLocation(){
        socket.on("update-driver-location"){ data, ack in
            if let rtd: SDriverRealTimeData = parseSocketData(data: data, type: SDriverRealTimeData.self) {
                DispatchQueue.main.async {
                    self.sDriverRealTimeData = rtd
                }
            }
        }
    }

    
    private func handleUIByOrderStatus(_ orderStatus: Int) {
        DataHolder.status = orderStatus
        switch orderStatus {
            case 1:
                setStatus(value: 2)
            case 2:
                setStatus(value: 3)
                guard let orderInfo = getOrderDetail else { return }
                let coordinates = getCoorWithDriverLoc(orderInfo: orderInfo)
                requestToDrawRoute(list: coordinates)
                
            case 3:
                setStatus(value: 4)
                
            case 4:
                setStatus(value: 5)
                
            case 5:
                showRateDriver.toggle()
                setStatus(value: 0)
                socket.off("update-driver-location")
                setupInitialListeners()
                
            case 6:
                setDefaults()
                
            default:
                print("Unexpected order state: \(orderStatus)")
        }
    }
    
    func setDefaults(){
        setStatus(value: 0)
        socket.off("update-driver-location")
        setupInitialListeners()
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
    
    @Published var locationHolder: [UserSelectedAddress] = []
    func locationUpdated(_ address: UserSelectedAddress, _ isSetIndex: Bool = false, _ index: Int = 0){
        if let lastAddress = locationHolder.last {
            if lastAddress.addressLocation.latitude == address.addressLocation.latitude &&
                lastAddress.addressLocation.longitude == address.addressLocation.longitude {
                return
            }
        }
        if isSetIndex {
            locationHolder[index] = address
        } else {
            locationHolder.append(address)
        }
        if status == 1 && locationHolder.count >= 2 {
            requestToDrawRoute(list: mapToRouteCoordinatesLatLng( locationHolder))
        }
    }
    
    func retainFirstElement() {
        if locationHolder.count > 1 {
            locationHolder.removeSubrange(1..<locationHolder.count)
        }
    }
}
