//
//  DriverFoundView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/08/24.
//

import SwiftUI

struct DriverFoundView: View {
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var socketViewModel: SocketViewModel

    @State private var isRideDetailsPresented = false
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                
                Spacer()
                
                topBar
                
                VStack(spacing: 16) {
                    let orderInfo = viewModel.getOrderDetail!
                    
                    if let car: Car = orderInfo.assignee?.car {
                        let num = car.regNum
                        let color = car.color
                        let carName = "\(color) \(car.brand) \(car.model)"
                        
                        VStack(spacing: 0){
                            HStack{
                                OrderStatusView()
                                Spacer()
                                
                                Text(num)
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 4)
                                    .background(.appGray)
                                    .cornerRadius(12)
                                    .foregroundColor(.txt)
                            }
                            
                            HStack{
                                Text(carName)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.txt)
                                
                                Spacer()
                                
                                let tariffIcon = UserDefaults.standard.string(forKey: Constants.TARIFF_ICON) ?? "Ekonom"
                                Image(imageNameForType(tariffIcon))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 18)
                            }
                        }
                    }
                    Divider()
                    
                    HStack(alignment: .top,spacing: 0) {
                        
                        VStack {
                            RemoteRoundedImage(image: viewModel.image, radius: 28, imageName: "profile-image")
                                .onAppear {
                                    viewModel.loadImage(fromURLString: getImageUrl(orderDetails: viewModel.getOrderDetail!)) }
                            
                            if let name = socketViewModel.sOrderInfo{
                                Text(name.driverFullName)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            
                        }) {
                            VStack {
                                Image("phone")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(12)
                                    .frame(width: 56, height: 56)
                                    .background(.appGray)
                                    .clipShape(Circle())
                                Text("call_to_driver")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            isRideDetailsPresented.toggle()
                        }) {
                            VStack {
                                Image("menu")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(12)
                                    .frame(width: 56, height: 56)
                                    .background(.appGray)
                                    .clipShape(Circle())
                                Text("details")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        Button(action: {
                        }) {
                            VStack {
                                Image("plus")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(12)
                                    .frame(width: 56, height: 56)
                                    .background(.appGray)
                                    .clipShape(Circle())
                                Text("add_second_space")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.1),radius: 24)
                .padding(.horizontal, 12)
                .padding(.top, 12)
                .edgesIgnoringSafeArea(.bottom)
                
            }
            BottomSheetView(isOpen: $isRideDetailsPresented,
                            minHeight: 0,
                            maxHeight: UIScreen.main.bounds.height) {
                RideDetailsView(viewModel: viewModel, socketViewModel: socketViewModel)
            }.edgesIgnoringSafeArea(.bottom)
            
        }
    }
    
    func OrderStatusView() -> some View {
        let status = viewModel.status
        var text: String = ""
        let minutes: Int = Int((viewModel.getOrderDetail?.distance ?? 2.0) * 1000 / (12*60))
        switch status {
            case 3:
                if minutes == 1 {
                    text = String(format: NSLocalizedString("status_arrival_time", comment: ""), minutes)
                } else {
                    text = String(format: NSLocalizedString("status_arrival_time_plural", comment: ""), minutes)
                }
            case 4:
                text = NSLocalizedString("status_driver_waiting", comment: "")
            case 5:
                text = NSLocalizedString("status_travel_started", comment: "")
            default:
                text = NSLocalizedString("status_driver_coming", comment: "")
        }
        
        return Text(text)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.txt)
            .padding(0)
    }

    
    private var topBar: some View {
        HStack {
            Button(action: {

            }) {
                DrawerBtn(name: "left-arrow", fromAssets: true, color: .txt)
            }
            Spacer()
            locationButton
        }
        .padding(.horizontal, 16)
    }
    
    var locationButton: some View {
        Button(action: {
            viewModel.findUserRealPosition(loc: viewModel.location)
        }) {
            DrawerBtn(name: "location_btn", fromAssets: true, color: .txt)
        }
        
    }
}
