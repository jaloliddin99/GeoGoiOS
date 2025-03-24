//
//  SearchScreenDialog.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import SwiftUI
import CoreLocation

struct SearchScreenDialog: View {
    @State var whereLocName: String = ""

    private var isSearchingLocation: Bool {
        return whereLocName.count > 3
    }
    @ObservedObject var viewModel: MainViewModel
    @StateObject var eSearchViewModel = ElasticSearchViewModel()

    
    var body: some View {
        let holder = viewModel.locationHolder
        VStack {
            DialogToolBar(showDialog: $viewModel.isSearchDialogShowing, title: "txt_where_to_go")
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                

                Text(holder.isEmpty ? "searching_with_dot" : holder[0].addressName)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                    .onChange(of: whereLocName) { oldValue, newValue in
                        if newValue.count > 3 {
                            print("dataRECEIVED \(newValue)")
                            eSearchViewModel.reverseLocation(address: whereLocName)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
            .padding(.top, 10)
        }
        .padding()
        
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 6) {
                
                if isSearchingLocation {
                    ForEach(eSearchViewModel.reverseLocations ?? [], id: \.lat) { reverseInfo in
                        ElasticSearchResult(searchInfo: reverseInfo, viewModel: viewModel)
                    }
                } else {
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
    var searchInfo: GeocodingResponseModel
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "location")
                .padding(8)
                .frame(maxWidth: 32, maxHeight: 32)
                .background(Color.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text(searchInfo.displayName)
                    .font(.system(size: 16))
                
                Text("\(String(searchInfo.distance)) \(searchInfo.unit)")
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
            let address = searchInfo.displayName
            let lat = searchInfo.lat
            let lon = searchInfo.lon
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
