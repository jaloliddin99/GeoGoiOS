//
//  DriverFoundView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/08/24.
//
import SwiftUI

struct DriverFoundView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var isRideDetailsPresented = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                topBar
                rideInformation
            }
            bottomSheet
        }
        .ignoresSafeArea()
    }
    
    private var topBar: some View {
        HStack {
            backButton
            Spacer()
            locationButton
        }
        .padding(.horizontal, 16)
    }
    
    private var backButton: some View {
        Button(action: {}) {
            DrawerBtn(name: "left-arrow", fromAssets: true, color: .txt)
        }
    }
    
    private var locationButton: some View {
        Button(action: {
            viewModel.FLAG_LOCATION_REQUESTED = true
            viewModel.requestUserLocation()
        }) {
            DrawerBtn(name: "location_btn", fromAssets: true, color: .txt)
        }
    }
    
    private var rideInformation: some View {
        VStack(spacing: 16) {
            if let orderInfo = viewModel.getOrderDetail, let car = orderInfo.assignee?.car {
                let carName = "\(car.color) \(car.brand) \(car.model)"
                carDetailsView(regNum: car.regNum, carName: carName)
            }
            
            Divider()
            driverInteractionButtons
        }
        .padding(16)
        .padding(.bottom, 20)
        .background(Color.white)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.1), radius: 24)
        .padding(.top, 12)
    }
    
    
    
    private func carDetailsView(regNum: String, carName: String) -> some View {
        VStack(spacing: 0) {
            HStack {
                let orderInfo = viewModel.getOrderDetail
                OrderStatusView(status: viewModel.status, distance: orderInfo?.distance ?? 2.0)
                Spacer()
                Text(regNum)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(.appGray)
                    .cornerRadius(12)
                    .foregroundColor(.txt)
            }
            
            HStack {
                Text(carName)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.txt)
                
                Spacer()
                
                Image(imageNameForType(UserDefaults.standard.string(forKey: Constants.TARIFF_ICON) ?? "Ekonom"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 18)
            }
        }
    }

    
    private var driverInteractionButtons: some View {
        HStack(alignment: .top, spacing: 0) {
            driverImage
            callButton
            detailsButton
            addButton
        }
    }
    
    private var driverImage: some View {
        VStack {
            RemoteRoundedImage(image: viewModel.image, radius: 28, imageName: "profile-image")
                .onAppear {
                    guard let detail = viewModel.getOrderDetail else { return }
                    viewModel.loadImage(fromURLString: getImageUrl(orderDetails: detail))
                }
            
            if let name = viewModel.sOrderInfo?.driverFullName {
                Text(name)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var callButton: some View {
        NavigationLink(destination: ChatView(viewModel: viewModel)) {
            interactionButtonView(iconName: "phone", label: "call_to_driver".localize())
        }
        .frame(maxWidth: .infinity)
    }
    
    private var detailsButton: some View {
        Button(action: {
            isRideDetailsPresented.toggle()
        }) {
            interactionButtonView(iconName: "menu", label: "details".localize())
        }
        .frame(maxWidth: .infinity)
    }
    
    private var addButton: some View {
        Button(action: {}) {
            interactionButtonView(iconName: "plus", label: "add_second_space".localize())
        }
        .frame(maxWidth: .infinity)
    }
    
    private func interactionButtonView(iconName: String, label: String) -> some View {
        VStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .padding(16)
                .frame(width: 56, height: 56)
                .background(.appGray)
                .clipShape(Circle())
            Text(LocalizedStringKey(label))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
    
    
    
    private var bottomSheet: some View {
        BottomSheetView(isOpen: $isRideDetailsPresented,
                        minHeight: 0,
                        maxHeight: UIScreen.main.bounds.height) {
            RideDetailsView(viewModel: viewModel, isOpen: $isRideDetailsPresented)
        }
    }
    
    
}
