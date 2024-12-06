//
//  RideDetailsView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/12/24.
//

import SwiftUI

struct RideDetailsView: View {
    
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
    
        VStack {
            
            VStack {
                let orderInfo = viewModel.getOrderDetail!
                OrderStatusView()
                
                Divider()
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Jaxongir 4.85")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.txt)
                        
                        
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
                            
                            Text("contact")
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
                            
                            Text("share")
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
                HStack {
                    Image(systemName: "creditcard.fill")
                    VStack(alignment: .leading){
                        Text("Оплата картой: 10000сум")
                            .font(.subheadline)
                        
                        Text("Uzcard ••• 7969")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {}) {
                        Text("edit")
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
                    Image("enable_gps")
                        .resizable()
                        .scaledToFit()
                        .padding(.vertical, 4)
                        .frame(width: 30, height: 30)
                    
                    Toggle("show_driver_where_i_am", isOn: .constant(true))
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
                    
                    Text("cancel_order")
                        .font(.body)
                        .foregroundColor(.red)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 16)
                .frame(height: 60)
            }
            .background(Color.white)
            .cornerRadius(16)
            
            
            Spacer()
            
            HStack {
                Image("cancel")
                    .resizable()
                    .padding(4)
                    .frame(width: 30, height: 30)
                
                Text("cancel_order")
                    .font(.body)
                    .foregroundColor(.red)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .cornerRadius(16, corners: [.topLeft, .topRight])

            
            
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
        
        return Text(text)
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    
    func OrderRoute() -> some View {
        VStack(spacing: 0) {
            HStack {
                Image("people_rise_hand")
                    .resizable()
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: NSLocalizedString("arrival_time", comment: ""), "10:32"))
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text("ул. Лабзак, 12/1")
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
            
            HStack {
                Image("plus")
                    .resizable()
                    .padding(4)
                    .frame(width: 30, height: 30)
                
                Text("add_stops")
                    .font(.body)
                    .foregroundColor(.txt)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.txt)
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            
            Divider()
                .padding(.trailing, 16)
                .padding(.leading, 56)
            
            HStack {
                Image(systemName: "flag.2.crossed")
                    .resizable()
                    .padding(.vertical, 4)
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("arrival")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("улица Алишера Навои, 16A")
                        .font(.body)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.txt)
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
        }
        .background(Color.white)
        .cornerRadius(16)
    }
    
    
}
