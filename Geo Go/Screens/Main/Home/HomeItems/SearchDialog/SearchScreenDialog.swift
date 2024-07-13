//
//  SearchScreenDialog.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import SwiftUI

struct SearchScreenDialog: View {
    @Binding var status: Int
    @Binding var showSearchView: Bool
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var eSearchViewModel =  ElasticSearchViewModel()
    
    @State private var myLocationName: String = ""
    @State private var whereLocName: String = ""
    private var isSearchingLocation: Bool {
        return whereLocName.count > 3
    }
        
    
    var body: some View {
        VStack {
            
            HStack(spacing: 0) {
                Button(action: {
                    showSearchView.toggle()
                }) {
                    Image(systemName: "xmark")
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Where are we going?")
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                Button("Done") {
                    showSearchView.toggle()
                }
                .font(.system(size: 16))
                .hidden()
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                
                Text(viewModel.currentAddress?.display_name ?? "Searching...")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.leading, 4)
            }
            .padding(.top, 10)
            
            HStack {
                Image(systemName: "location")
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                
                TextField("Search...", text: $whereLocName)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.leading, 4)
                    .onChange(of: whereLocName) {
                        eSearchViewModel.reverseLocation(address: whereLocName)
                    }
                    
            }
            .padding(.top, 10)
        }
        .padding()
        
        
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 6) {
                
                if isSearchingLocation {
                    ForEach(eSearchViewModel.reverseLocations?.features ?? [], id: \.properties.id) { reverseInfo in
                        ElasticSearchResult(status: $status, searchInfo: reverseInfo, viewModel: viewModel)
                    }
                }else{
                    ForEach(viewModel.addressHistoryResponse ?? [], id: \.id) { orderInfo in
                        SearchHistory(status: $status, orderInfo: orderInfo, viewModel: viewModel)
                    }
                }
            }
            .padding(.horizontal, 12)
            
        }
    }
}

struct ElasticSearchResult: View {
    @Binding var status: Int
    var searchInfo: GeocodeFeature
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "location")
                .padding(8)
                .frame(maxWidth: 32, maxHeight: 32)
                .background(Color.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text(searchInfo.properties.name)
                    .font(.system(size: 16))
                
                Text("\(String(searchInfo.properties.distance ?? 0)) km")
                    .opacity(0.4)
                    .font(.system(size: 12))
            }
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.leading, 4)
        .onTapGesture(perform: {
            
            let address = searchInfo.properties.name
            let lat = searchInfo.geometry.coordinates[0]
            let lon = searchInfo.geometry.coordinates[1]
            let location = LatLng(latitude: lat, longitude: lon)
            let uAddress = UserSelectedAddress(addressName: address, addressLocation: location)
            viewModel.locationUpdated(uAddress)
            status = 1
            
        })
        
    }
}


struct SearchHistory: View {
    @Binding var status: Int
    var orderInfo: ShortOrderInfo
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .padding(8)
                .frame(maxWidth: 32, maxHeight: 32)
                .background(Color.white)
                .clipShape(Circle())
            
            
            VStack(alignment: .leading){
                Text(orderInfo.route[orderInfo.route.count-1].name)
                    .font(.system(size: 16))
                
                Text("\(orderInfo.state) km")
                    .opacity(0.4)
                    .font(.system(size: 12))
            }
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.leading, 4)
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


//struct SearchScreenDialog_Previews: PreviewProvider {
//    @State static var showSearchView = true
//
//
//    static var previews: some View {
//        SearchScreenDialog(showSearchView: $showSearchView)
//    }
//}
