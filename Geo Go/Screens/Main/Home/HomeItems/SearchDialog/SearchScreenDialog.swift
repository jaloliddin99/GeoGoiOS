//
//  SearchScreenDialog.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import SwiftUI
import CoreLocation

struct SearchScreenDialog: View {
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var eSearchViewModel =  ElasticSearchViewModel()
    
    @State private var myLocationName: String = ""
    @State private var whereLocName: String = ""
    private var isSearchingLocation: Bool {
        return whereLocName.count > 3
    }
    
    var body: some View {
        VStack {
            DialogToolBar(showDialog: $viewModel.isSearchDialogShowing, title: "txt_where_to_go")
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                
                Text(viewModel.currentAddress?.display_name ?? "searching_with_dot")
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
                
                TextField("enter_address_here", text: $whereLocName)
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
                        ElasticSearchResult(searchInfo: reverseInfo, viewModel: viewModel)
                    }
                }else{
                    ForEach(viewModel.addressHistoryResponse ?? [], id: \.id) { orderInfo in
                        SearchHistory(orderInfo: orderInfo, viewModel: viewModel)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}

struct ElasticSearchResult: View {
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
        .cornerRadius(10)
        .padding(.leading, 4)
        .onTapGesture(perform: {
            let address = searchInfo.properties.name
            let lat = searchInfo.geometry.coordinates[1]
            let lon = searchInfo.geometry.coordinates[0]
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let uAddress = UserSelectedAddress(addressName: address, addressLocation: location)
            viewModel.locationUpdated(uAddress)
            viewModel.setStatus(value: 1)
            viewModel.isSearchDialogShowing = false
            if viewModel.status == 1 {
                viewModel.serviceTariffRequest()
            }
          
        })
        
    }
}


struct SearchHistory: View {
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
        .cornerRadius(10)
        .padding(.leading, 4)
        .onTapGesture(perform: {
            let address = orderInfo.route[orderInfo.route.count-1]
            let name = address.name
            let lat = address.position?.lat ?? 0.0
            let lon = address.position?.lon ?? 0.0
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let uAddress = UserSelectedAddress(addressName: name, addressLocation: location)
            viewModel.locationUpdated(uAddress)
            viewModel.isSearchDialogShowing = false
            viewModel.setStatus(value: 1)
            if viewModel.status == 1 {
                viewModel.serviceTariffRequest()
            }
        })
        
    }
}
