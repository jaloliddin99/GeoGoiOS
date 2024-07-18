//
//  SearchTextView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import SwiftUI

struct SearchTextView: View {
    @ObservedObject var viewModel: MainViewModel
    
    
    var body: some View {
        ZStack{
            HStack{
                Button {
                    viewModel.isSearchDialogShowing = true
                } label: {
                    Text("Where are we going?")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black.opacity(0.7))
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                Button(action: {
                    viewModel.setStatus(value: 1)
                }, label: {
                    Text("Order ->")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .frame(maxHeight: 36)
                        .foregroundColor(.white)
                        .background(Color.main)
                        .cornerRadius(10)
                        .padding(.trailing, 12)
                    
                })
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal, 12)
        
        
    }
}







struct ShortOrderInfoView: View {
    @ObservedObject var viewModel: MainViewModel
    var orderInfo: ShortOrderInfo
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "bookmark.fill")
                .padding(8)
                .frame(maxWidth: 32, maxHeight: 32)
                .background(Color.white)
                .cornerRadius(12)
            
            VStack(alignment: .leading){
                Text(orderInfo.route[orderInfo.route.count-1].name)
                    .font(.system(size: 16))
                Text("\(orderInfo.state) min")
                    .opacity(0.4)
                    .font(.system(size: 12))
            }
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 4)
        .onTapGesture(perform: {
            let address = orderInfo.route[orderInfo.route.count-1]
            let name = address.name
            let lat = address.position?.lat ?? 0.0
            let lon = address.position?.lon ?? 0.0
            let location = LatLng(latitude: lat, longitude: lon)
            let uAddress = UserSelectedAddress(addressName: name, addressLocation: location)
            viewModel.locationUpdated(uAddress)
            viewModel.setStatus(value: 1)
        })
    }
}





