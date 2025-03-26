//
//  DriverInfoView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 26/03/25.
//

import SwiftUI


struct DriverInfoView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            let orderInfo = viewModel.getOrderDetail
            OrderStatusView(status: viewModel.status, distance: orderInfo?.distance ?? 2.0)
            
            Divider()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let info = viewModel.sOrderInfo {
                        Text("\(info.driverFullName) ⭐️ \(String(format: "%.2f", info.driverRating))")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.txt)
                    }

                    if let car = orderInfo?.assignee?.car {
                        Text("\(car.color) \(car.brand) \(car.model)")
                            .font(.subheadline)
                            .foregroundColor(.txt)
                        
                        Text(car.regNum)
                            .font(.system(size: 20, weight: .medium, design: .monospaced))
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
                            .padding(.top, 12)
                    }
                }
                
                Spacer()
                
                HStack {
                    let tariffIcon = UserDefaults.standard.string(forKey: Constants.TARIFF_ICON) ?? "Ekonom"
                    Image(imageNameForType(tariffIcon))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 30)
                    
                    RemoteRoundedImage(image: viewModel.image, radius: 28, imageName: "profile-image")
                        .onAppear {
                            viewModel.loadImage(fromURLString: getImageUrl(orderDetails: orderInfo!))
                        }
                }
            }
            
            ActionButtons(viewModel: viewModel)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .background(Color.white)
        .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
    }
}

struct OrderStatusView: View {
    let status: Int
    let distance: Double
    
    var body: some View {
        let minutes = Int((distance * 1000) / (12 * 60))
        let statusText: String
        
        switch status {
            case 3:
                statusText = minutes == 1 ? "status_arrival_time".localize() : "status_arrival_time_plural".localize()
            case 4:
                statusText = "status_driver_waiting".localize()
            case 5:
                statusText = "status_travel_started".localize()
            default:
                statusText = "status_driver_coming".localize()
        }
        
        return Text(String(format: statusText, minutes))
            .font(.title2)
            .fontWeight(.semibold)
    }
}

struct ActionButtons: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack {
            NavigationLink(destination: ChatView(viewModel: viewModel)) {
                ActionButton(icon: "phone", label: "contact")
            }
            
            ActionButton(icon: "share", label: "share") {
                openLink("https://skt.geogo.io/\(DataHolder.orderId)")
            }
        }
        .padding(.top, 12)
    }
    
    func openLink(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let label: String
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(label.localize())
                    .font(.footnote)
                    .foregroundColor(.txt)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.appGray)
        .cornerRadius(16)
    }
}
