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
        
        print("text entered \(amount)")
        print(res)
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
            HStack(spacing: 0) {
                Button(action: {
                    viewModel.isShowBonusDialog = false
                }) {
                    Image(systemName: "xmark")
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Circle())
                }
                
                Spacer()
                Text("Bonus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.main)
                
                Spacer()
                
                Button("Done") {
                    viewModel.isShowBonusDialog = false
                }
                .font(.system(size: 16))
                .hidden()
            }
            
            Text("Your bonuses")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.main)
                .padding(.top, 16)
            
            let bonus = viewModel.bonusResponse
            Text(formatNumberWithSpaces(bonus.balance)!)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.main)
                .padding(.top, 2)
            
            Text("In the event of an increase in value, the remaining amount of bonuses will be returned to your account")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 12)
            
            
            Text("Pay for part of the trip with bonuses")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 24)
            
            let hint = "min \(Int(bonus.capabilities.min)), max \(Int(bonus.capabilities.max)) uzs"
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
                    GGButton(title: "No Bonus Order", bgColor: .gray)
                        .frame(maxWidth: .infinity)
                }
                Button {
                    let createOrder =
                    getCreateOrderRoute(addressList: addresses, bonusInt: Double(txtAmount)!)
                    viewModel.createOrder(lat: lat, lon: lon,
                        createOrderRequest: createOrder)
                } label: {
                    GGButton(title: "Order")
                        .frame(maxWidth: .infinity)
                        .disabled(isButtonDisabled)
                        .opacity(isButtonDisabled ? 0.5 : 1.0)
                }
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .padding()
    }
}
