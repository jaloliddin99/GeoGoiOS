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
            DriverInfoView(viewModel: viewModel)
            
            OrderRoute(routeItems: viewModel.getOrderDetail?.route ?? [])
            
            PaymentView(paymentMethod: .constant("credit_card"), viewModel: viewModel)

            Spacer()
        }
        .background(.appGray)
    }
}


struct PaymentView: View {
    @Binding var paymentMethod: String
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            paymentMethodSection
            
            Divider()
                .padding(.trailing, 16)
                .padding(.leading, 56)
            
            locationToggleSection
            
            Divider()
                .padding(.trailing, 16)
                .padding(.leading, 56)
            
            cancelOrderSection
        }
        .background(Color.white)
        .cornerRadius(16)
    }
}

private extension PaymentView {
    var paymentMethodSection: some View {
        HStack {
            let isCardMethod = paymentMethod == "credit_card"
            Image(systemName: isCardMethod ? "creditcard.fill" : "dollarsign.circle")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(isCardMethod ? "payment_via_card".localize() : "payment_via_cash".localize())
                    
                    Text(String(Int(getOrderPrice())))
                        .customStyle()
                    
                    Text(getCurrencySymbol())
                        .customStyle(size: 14)
                }
                
                if isCardMethod {
                    HStack(spacing: 4) {
                        Text("card")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        if let card = UserDefaults.standard.string(forKey: Constants.SELECTED_CARD) {
                            Text(card.suffix(4))
                                .foregroundColor(.txt)
                        }
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
                    .background(Color.appGray)
                    .cornerRadius(20)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }
    
    var locationToggleSection: some View {
        HStack {
            Image("enable_gps".localize())
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Toggle("show_driver_where_i_am".localize(), isOn: $viewModel.isLocationSharingEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .onChange(of: viewModel.isLocationSharingEnabled) { isEnabled in
                    viewModel.updateLocationSharing(isEnabled)
                }
            
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }
    
    var cancelOrderSection: some View {
        HStack {
            Image("cancel")
                .resizable()
                .frame(width: 30, height: 30)
                .padding(4)
            
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
}
