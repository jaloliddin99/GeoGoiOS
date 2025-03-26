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
            viewModel.findUserRealPosition(loc: viewModel.location)
        }) {
            DrawerBtn(name: "location_btn", fromAssets: true, color: .txt)
        }
    }
    
    private var rideInformation: some View {
        VStack(spacing: 16) {
            orderDetails
            Divider()
            driverInteractionButtons
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 24)
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    private var orderDetails: some View {
        if let orderInfo = viewModel.getOrderDetail, let car = orderInfo.assignee?.car {
            let carName = "\(car.color) \(car.brand) \(car.model)"
            carDetailsView(regNum: car.regNum, carName: carName)
        }
    }
    
    private func carDetailsView(regNum: String, carName: String) -> some View {
        VStack(spacing: 0) {
            HStack {
                OrderStatusView()
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
        
        return Text(text.localize())
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.txt)
            .padding(0)
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
                    viewModel.loadImage(fromURLString: getImageUrl(orderDetails: viewModel.getOrderDetail!))
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
                .padding(12)
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
            RideDetailsView(viewModel: viewModel)
        }
                        .edgesIgnoringSafeArea(.bottom)
    }
    
    
}
