//
//  RideDetailsView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/12/24.
//

import SwiftUI

struct RideDetailsView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State var paymentMethod: String = getPaymentMethod()

    var body: some View {
        VStack {
            
            VStack {
                let orderInfo = viewModel.getOrderDetail!
                OrderStatusView()
                
                Divider()
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        if let info = viewModel.sOrderInfo {
                            let nameAndRating = info.driverFullName + " ⭐️ \(info.driverRating)"
                            Text(nameAndRating)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.txt)
                        }
                        
                        if let car: Car = orderInfo.assignee?.car {
                            let num = car.regNum
                            let color = car.color
                            let carName = "\(color) \(car.brand) \(car.model)"
                            
                            Text(carName)
                                .font(.subheadline)
                                .foregroundColor(.txt)
                            Text(num)
                                .font(.system(size: 20, weight: .medium, design: .monospaced))
                                .padding(6)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black)
                                )
                                .padding(.top, 12)
                        }
                        
                    }
                    Spacer()
                    
                    HStack(alignment: .center){
                        
                        
                        let tariffIcon = UserDefaults.standard.string(forKey: Constants.TARIFF_ICON) ?? "Ekonom"
                        Image(imageNameForType(tariffIcon))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 30)
                        
                        RemoteRoundedImage(image: viewModel.image, radius: 28, imageName: "profile-image")
                            .onAppear {
                                viewModel.loadImage(fromURLString: getImageUrl(orderDetails: viewModel.getOrderDetail!)) }
                    }
                }
                
                HStack {
                    Button(action: {}) {
                        HStack {
                            Image("phone")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("contact".localize())
                                .font(.footnote)
                                .foregroundColor(.txt)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.appGray)
                    .cornerRadius(16)
                    
                    
                    Button(action: {}) {
                        HStack {
                            Image("share")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("share".localize())
                                .font(.footnote)
                                .foregroundColor(.txt)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.appGray)
                    .cornerRadius(16)
                    
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .background(.white)
            .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
            
            OrderRoute()
            
            
            VStack(spacing: 0) {
                
                let isCardMethod = paymentMethod == "credit_card"
                HStack {
                    
                    Image(systemName: isCardMethod ? "creditcard.fill" : "dollarsign.circle")
                    VStack(alignment: .leading){
                        
                        HStack(alignment: .bottom,spacing: 4){
                            Text(isCardMethod ? "payment_via_card".localize() : "payment_via_cash".localize())
                            
                        }
                        
                        if isCardMethod {
                            HStack(alignment: .bottom,spacing: 4) {
                                Text("card")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                let card = UserDefaults.standard.string(forKey: Constants.SELECTED_CARD)!
                                Text(card.suffix(4))
                                    .foregroundColor(.txt)
                            }
                        }
                        
                    }
                    Spacer()
                    
                    NavigationLink(destination: PaymentScreen(paymentMethod: $paymentMethod)) {
                        Text("edit".localize())
                            .font(.subheadline)
                            .foregroundColor(.txt)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.appGray)
                            .cornerRadius(20)
                    }
                
                  
                }
                .padding(.horizontal, 16)
                .frame(height: 60)
                
                Divider()
                    .padding(.trailing, 16)
                    .padding(.leading, 56)
                
                HStack{
                    Image("enable_gps".localize())
                        .resizable()
                        .scaledToFit()
                        .padding(.vertical, 4)
                        .frame(width: 30, height: 30)
                    
                    Toggle("show_driver_where_i_am".localize(), isOn: .constant(true))
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                }
                .padding(.horizontal, 16)
                .frame(height: 60)
                
                
                Divider()
                    .padding(.trailing, 16)
                    .padding(.leading, 56)
                
                HStack {
                    Image("cancel")
                        .resizable()
                        .padding(4)
                        .frame(width: 30, height: 30)
                    
                    Text("cancel_order".localize())
                        .font(.body)
                        .foregroundColor(.red)
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 16)
                .frame(height: 60)
                .onTapGesture {
                    viewModel.showCancelOrderAlert.toggle()
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            
            Spacer()
            
            
        }
        .background(.appGray)
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
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    
    func OrderRoute() -> some View {
        let routeItems = viewModel.getOrderDetail?.route ?? []

        return VStack(spacing: 0) {
            
            ForEach(0..<routeItems.count, id: \..self) { index in
                let routeItem = routeItems[index]
                
                if index == 0 {
                    HStack {
                        Image("people_rise_hand")
                            .resizable()
                            .frame(width: 30, height: 30)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: NSLocalizedString("arrival_time".localize(), comment: ""), "10:32"))
                                .font(.footnote)
                                .lineLimit(1)
                                .foregroundColor(.gray)
                            
                            Text(routeItem.point.info.alias ?? "Unknown Address")
                                .lineLimit(1)
                                .font(.body)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.txt)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 60)
                    
                    Divider()
                        .padding(.trailing, 16)
                        .padding(.leading, 56)
                }
                
                if index > 2 && index != 0 && index != routeItems.count - 1{
                    HStack {
                        Image(systemName: "pin.fill")
                            .resizable()
                            .padding(.vertical, 4)
                            .frame(width: 30, height: 30)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("arrival".localize())
                                .font(.system(size: 14))
                                .lineLimit(1)
                                .foregroundColor(.gray)
                            Text(routeItem.point.info.alias ?? "Unknown address")
                                .font(.body)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.txt)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 60)
                    
                    Divider()
                        .padding(.trailing, 16)
                        .padding(.leading, 56)
                }
                
                
                if index == routeItems.count - 1 {
                    HStack {
                        Image("plus")
                            .resizable()
                            .padding(4)
                            .frame(width: 30, height: 30)
                        
                        Text("add_stops".localize())
                            .font(.body)
                            .foregroundColor(.txt)
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.txt)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 60)
                }
                
                if routeItems.count > 1 && index == routeItems.count - 1{
                    Divider()
                        .padding(.trailing, 16)
                        .padding(.leading, 56)
                    
                    HStack {
                        Image(systemName: "flag.2.crossed")
                            .resizable()
                            .padding(.vertical, 4)
                            .frame(width: 30, height: 30)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("arrival".localize())
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text(routeItem.point.info.alias ?? "Unknown address")
                                .lineLimit(1)
                                .font(.body)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.txt)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 60)
                }
                
                
                
            }
           
        }
        .background(Color.white)
        .cornerRadius(16)
    }
    

    
}
