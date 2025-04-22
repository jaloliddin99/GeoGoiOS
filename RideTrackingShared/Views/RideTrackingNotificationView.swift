//
//  RideTrackingNotificationView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//

import SwiftUI
import CoreLocation


public struct RideTrackingNotificationView: View {
    
    let car: CarModel
    let initialLocation: CLLocationCoordinate2D
    let clientLocation: CLLocationCoordinate2D
    @ObservedObject public var viewModel: NotificationViewModel
    @State var arrivalTime: Int = 0
    @State private var sliderValue: Float = 0
    
    public init(car: CarModel, initialLocation: CLLocationCoordinate2D, clientLocation: CLLocationCoordinate2D, viewModel: NotificationViewModel) {
        self.car = car
        self.initialLocation = initialLocation
        self.clientLocation = clientLocation
        self.viewModel = viewModel
    }

    
    public var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 12) {
                    Image("logo")
                        .resizable()
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text("arrive_in".localize())
                                .font(.system(size: 16, weight: .bold))
                            Text("\(arrivalTime)")
                                .font(.system(size: 16, weight: .bold))
                            Text("min".localize())
                                .font(.system(size: 16, weight: .bold))
                        }
                        
                        HStack (spacing: 4){
                            Text(car.color)
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.7))
                            Text(car.brand)
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.7))
                            Text(car.model)
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.7))
                        }
                    }
                }
                
                Spacer()
                
                VStack{
                    Text(car.regNum)
                        .font(.system(size: 15, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(white: 0.85))
                        .cornerRadius(8)
                    
//                    Image(imageNameForType(UserDefaults.standard.string(forKey: Constants.TARIFF_ICON) ?? "Ekonom"))
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 40, height: 18)
                    
                }
            }
            
            CustomThumbSlider(value: $sliderValue)
                .frame(height: 40)
                .padding()
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(height: 110)
        .background(Color.mint)
        .cornerRadius(16)
        .padding(.horizontal)
        .onReceive(viewModel.$driverLocation) { data in
            guard let loc = data else { return }
            calculateRemainingTime(from: CLLocationCoordinate2D(latitude: loc.lat, longitude: loc.lon), to: clientLocation)
        }
    }
    
    func calculateRemainingTime(from initialLocation: CLLocationCoordinate2D, to clientLocation: CLLocationCoordinate2D){
        let distance = initialLocation.distance(to: clientLocation)
        let speed = 15
        let time = (Int(distance) / speed) / 60
        self.arrivalTime = time
        
        let distanceToDriver = initialLocation.distance(to: self.initialLocation)
        let distanceToClient = initialLocation.distance(to: self.clientLocation)
        
        let distanceInTotal = distanceToDriver + distanceToClient
        let findProgress = (distanceToDriver / distanceInTotal) * 100
        
        sliderValue = Float(findProgress)
        
    }
}
