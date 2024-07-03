//
//  SearchScreenDialog.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import SwiftUI

struct SearchScreenDialog: View {
    
    @Binding var showSearchView: Bool
    @ObservedObject var viewModel: MainViewModel

    @State private var myLocationName: String = ""
    @State private var whereLocName: String = ""
 
    var body: some View {
        VStack {
            
            HStack(spacing: 0) {
                Button(action: {
                    showSearchView.toggle()
                }) {
                    Image(systemName: "xmark")
                        .padding()
                        .background(Color.gray.opacity(0.2))
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
                    .background(Color.gray.opacity(0.2))
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
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.leading, 4)
            }
            .padding(.top, 10)
        }
        .padding()
        
        
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 6) {
                ForEach(viewModel.addressHistoryResponse ?? [], id: \.id) { orderInfo in
                    SearchHistory(orderInfo: orderInfo)
                }
            }
            .padding(.horizontal, 12)
            
        }
    }
}

struct SearchHistory: View {
    var orderInfo: ShortOrderInfo
    
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
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .padding(.leading, 4)
        
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
