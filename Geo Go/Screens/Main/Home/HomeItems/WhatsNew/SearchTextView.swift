//
//  SearchTextView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import SwiftUI

struct SearchTextView: View {
    @Binding var status: Int
    @ObservedObject var viewModel: MainViewModel
    @State private var showSearchView = false
    
    
    var body: some View {
        ZStack{
            HStack{
                Button {
                    showSearchView.toggle()
                } label: {
                    Text("Where are we going?")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black.opacity(0.7))
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showSearchView) {
                    VStack{
                        SearchScreenDialog(status: $status,
                                           showSearchView: $showSearchView, 
                                           viewModel: viewModel)
                        Spacer()
                    }
                }
                
                
                Button(action: {
                    let address = viewModel.currentAddress
                    let addressName = address?.display_name ?? "Picked Location"
                    let lat = address?.lat ?? "0.0"
                    let lon = address?.lon ?? "0.0"
                    let location = LatLng(latitude: Double(lat) ?? 0.0, longitude: Double(lon) ?? 0.0)
                    
                    let uAddress = UserSelectedAddress(addressName: addressName, addressLocation: location)
                    viewModel.locationUpdated(uAddress)
                    status = 1
                    
                }, label: {
                    Text("Order ->")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .padding(.leading, 12)
                        .padding(.trailing, 12)
                        .frame( maxHeight: 36)
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
    @Binding var status: Int
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
            status = 1
        })
    }
}





