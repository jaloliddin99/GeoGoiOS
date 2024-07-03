//
//  SearchTextView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import SwiftUI

struct SearchTextView: View {
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
                        SearchScreenDialog(showSearchView: $showSearchView, viewModel: viewModel)
                        Spacer()
                    }
                }
                
                
                Button(action: {
                    
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
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal, 4)
    }
}





