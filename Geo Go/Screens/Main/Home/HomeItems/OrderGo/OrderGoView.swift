//
//  OrderGoView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import SwiftUI

struct OrderGoView: View {
    @Binding var status: Int
    @ObservedObject var mainViewModel: MainViewModel
    
    @State private var showWishDialog = false
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Button(action: {
                    mainViewModel.locationHolder.removeAll()
                    status = 0
                }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(12)
                        .frame(width: 50, height: 50)
                        .background(Circle()
                            .fill(Color.white)
                            .shadow(radius: 2))
                })
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "location")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(12)
                        .frame(width: 50, height: 50)
                        .background(Circle()
                            .fill(Color.white)
                            .shadow(radius: 2))
                })
            }
            .padding(.horizontal, 12)
            
            VStack(spacing: 4){
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(mainViewModel.tariff?.tariffs ?? [], id: \.id) { orderInfo in
                            CarSelectionView(item: orderInfo)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    .padding(.bottom, 4)
                    .frame(maxHeight: 120)
                }
                
                
                HStack{
                    Image(systemName: "circle")
                        .opacity(0.5)
                    
                    if !mainViewModel.locationHolder.isEmpty {
                        Text(mainViewModel.locationHolder[0].addressName)
                            .fontWeight(.medium)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                
                HStack{
                    Image(systemName: "circle")
                        .opacity(0.5)
                    
                    let count = mainViewModel.locationHolder.count
                    
                    if count == 1{
                        Text("Where are we going?")
                            .fontWeight(.medium)
                            .foregroundColor(Color.black.opacity(0.5))
                        
                        Spacer()
                        
                    }else if count > 1 {
                        Text("\(count-1) picked location")
                            .fontWeight(.medium)
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                
                
                Divider()
                    .padding(.horizontal, 12)
                HStack(alignment: .center){
                    Image(systemName: "dollarsign.circle")
                        .opacity(0.5)
                    Text("Cash")
                    Spacer()
                    Divider().frame(height: 24)
                    
                    Spacer()
                    
                    Button(action: {
                        showWishDialog.toggle()
                    }, label: {
                        Image(systemName: "text.aligncenter")
                            .opacity(0.5)
                            .foregroundColor(.black)
                        
                        Text("Wishes")
                            .foregroundColor(.black)
                    })
                    .sheet(isPresented: $showWishDialog){
                        DialogWish(dialogWish: $showWishDialog)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                
                Button(action: {}
                       , label: {
                    GGButton(title: "Order")
                })
                .padding(.horizontal, 12)
                .padding(.bottom, 32)
                
            }
            .background(Color.white)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            .padding(.top, 12)
            .shadow(radius: 2)
            
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

//struct OrderGoView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderGoView(status: 5)
//    }
//}
