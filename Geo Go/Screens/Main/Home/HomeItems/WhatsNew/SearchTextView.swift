//
//  SearchTextView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import SwiftUI
import CoreLocation

struct SearchTextView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        ZStack{
            HStack{
                HStack(alignment: .center){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.leading, 12)
                    
                    
                    Text("txt_where_to_go".localize())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black.opacity(0.7))
                        .cornerRadius(10)
                    
                    Spacer()
                }
                .frame(minHeight: 56, maxHeight: 56)
                .onTapGesture {
                    viewModel.isSearchDialogShowing = true
                }
               
                HStack(alignment: .center, spacing: 8){
                    Text("txt_order_with_arrow".localize())
                        .font(.system(size: 14, weight: .medium))
                        .padding(.leading, 8)
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(minWidth: 17, maxWidth: 17, minHeight: 11, maxHeight: 11)
                        .padding(.trailing, 8)
                    
                }
                .frame(maxHeight: .infinity)
                .background(.main)
                .cornerRadius(12)
                .padding(.trailing, 8)
                .padding(.vertical, 8)
                .onTapGesture {
                    viewModel.setStatus(value: 1)
                }
            }
        }
        .frame(height: 56)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        
        
    }
}







struct ShortOrderInfoView: View {
    @ObservedObject var viewModel: MainViewModel
    var orderInfo: ShortOrderInfo
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "bookmark.fill")
                .foregroundColor(.main)
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
        .frame(maxWidth: 250, maxHeight: 56)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        
        .onTapGesture(perform: {
            let address = orderInfo.route[orderInfo.route.count-1]
            let name = address.name
            let lat = address.position?.lat ?? 0.0
            let lon = address.position?.lon ?? 0.0
            
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let uAddress = UserSelectedAddress(addressName: name, addressLocation: location)
            viewModel.locationUpdated(uAddress)
            viewModel.setStatus(value: 1)
        })
    }
}





