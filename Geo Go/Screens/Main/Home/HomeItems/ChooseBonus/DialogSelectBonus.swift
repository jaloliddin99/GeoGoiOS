//
//  DialogSelectBonus.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/07/24.
//

import SwiftUI

struct DialogSelectBonus: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var txtAmount: String = ""
    
    var isButtonDisabled: Bool {
        let res = viewModel.bonusResponse
        let amount: Double = Double(txtAmount) ?? 0
        if res.balance == 0{
            return true
        }else if (amount <= res.capabilities.max && amount >= res.capabilities.min) {
            return false
        } else {
            return true
        }
         
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            
            
            Text("your_bonuses")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.main)
                .padding(.top, 16)
            
            let bonus = viewModel.bonusResponse
            Text(formatNumberWithSpaces(bonus.balance))
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.main)
                .padding(.top, 2)
            
            Text("bonus_desc")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 12)
            
            
            Text("bonus_short_desc")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 24)
            
          
            let minText = NSLocalizedString("min", comment: "")
            let maxText = NSLocalizedString("max", comment: "")
            
            let hint = String(
                format: NSLocalizedString("hint_format", comment: ""),
                minText,
                Int(bonus.capabilities.min),
                maxText,
                Int(bonus.capabilities.max)
            )


            TextField(hint, text: $txtAmount)
                .keyboardType(.decimalPad)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.top, 8)
                
            
            Spacer()
            
            HStack{
                let addresses = viewModel.locationHolder
                let lat = addresses[0].addressLocation.latitude
                let lon = addresses[0].addressLocation.longitude
                Button {
                    let createOrder = getCreateOrderRoute(
                        addressList: addresses,bonusInt: 0)
                    viewModel.createOrder(lat: lat,lon: lon, createOrderRequest: createOrder)

                } label: {
                    GGButton(title: "no_bonus_order", bgColor: .gray)
                        .frame(maxWidth: .infinity)
                }
                Button {
                    let createOrder =
                    getCreateOrderRoute(addressList: addresses, bonusInt: Double(txtAmount)!)
                    viewModel.createOrder(lat: lat, lon: lon,
                        createOrderRequest: createOrder)
                } label: {
                    GGButton(title: "order")
                        .frame(maxWidth: .infinity)
                        .disabled(isButtonDisabled)
                        .opacity(isButtonDisabled ? 0.5 : 1.0)
                }
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .edgesIgnoringSafeArea(.bottom)
    }
}
