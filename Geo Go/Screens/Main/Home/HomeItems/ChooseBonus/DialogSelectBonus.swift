//
//  DialogSelectBonus.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/07/24.
//

import SwiftUI

struct DialogSelectBonus: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var inputText: String = ""

    var isButtonDisabled: Bool {
        let res = viewModel.bonusResponse
        let amount: Double = Double(inputText) ?? 0
        if res.balance == 0 {
            return true
        }else if (amount <= res.capabilities.max && amount >= res.capabilities.min) {
            return false
        } else {
            return true
        }
         
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            
            Text("your_bonuses")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.main)
                .padding(.top, 16)
            
            let bonus = viewModel.bonusResponse
            Text(formatNumberWithSpaces(bonus.balance))
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.main)
            
            Spacer()
            
            Text("bonus_desc")
                .font(.system(size: 16, weight: .medium))
            
          
            let minText = NSLocalizedString("min", comment: "")
            let maxText = NSLocalizedString("max", comment: "")
            
            
            let hint = String(
                format: NSLocalizedString("hint_format", comment: ""),
                minText,
                Int(bonus.capabilities.min),
                maxText,
                Int(bonus.capabilities.max)
            )
            
            Text(hint)
                .foregroundColor(.main)
                .font(.system(size: 20, weight: .medium))
            
            Spacer()

            VStack(alignment: .leading, spacing: 4){
                Text("bonus_short_desc")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                
                HStack(alignment: .bottom){
                    Text("enter_amount")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .regular))
                        .padding(.top, 24)
                    
                    Spacer()
                    
                    
                    Text(getBonusAmount(inputText: inputText))
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))

                    Spacer()
                    
                    Button {
                        if bonus.balance > bonus.capabilities.max {
                            inputText = String(Int(bonus.capabilities.max))
                        }else if bonus.balance <= bonus.capabilities.max
                                    && bonus.balance >= bonus.capabilities.min {
                            inputText = String(Int(bonus.balance))
                        }
                    } label: {
                        Image("magnet")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }


                }
            }
            .padding(16)
            .background(.main)
            .cornerRadius(20)
            .shadow(radius: 12)
            
            Spacer()
            
            CustomKeyboardView(inputText: $inputText)
                .background(.blue)
            
            HStack{
                let addresses = viewModel.locationHolder
                let lat = addresses[0].addressLocation.latitude
                let lon = addresses[0].addressLocation.longitude
                Button {
                    let createOrder = getCreateOrderRoute(addressList: addresses,bonusInt: 0)
                    viewModel.createOrder(lat: lat,lon: lon, createOrderRequest: createOrder)

                } label: {
                    GGButton(title: "no_bonus_order")
                        .frame(maxWidth: .infinity)
                }
                Button {
                    let createOrder =
                    getCreateOrderRoute(addressList: addresses, bonusInt: Double(inputText)!)
                    viewModel.createOrder(lat: lat, lon: lon,
                        createOrderRequest: createOrder)
                } label: {
                    GGButton(title: "order_with_bonus", isDisabled: isButtonDisabled)
                        .frame(maxWidth: .infinity)
                }
                .disabled(isButtonDisabled)

            }
            .frame(maxWidth: .infinity)
            
        }
        .padding(.horizontal, 16)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func getBonusAmount(inputText: String) -> String {
        let sign = (UserDefaults.standard.string(forKey: Constants.sign) ?? "uzs").lowercased()

        return "\(inputText)\(inputText.isEmpty ? "" : " \(sign)")"
    }
}
