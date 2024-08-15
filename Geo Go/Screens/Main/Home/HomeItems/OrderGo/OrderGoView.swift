//
//  OrderGoView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import SwiftUI

struct OrderGoView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var showWishDialog = false
    @State private var selectedItem: ServiceTariff?
     
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Button(action: {
                    mainViewModel.retainFirstElement()
                    mainViewModel.setStatus(value: 0)
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
                
            }
            .padding(.horizontal, 12)
            
            let tariffs = mainViewModel.tariff?.tariffs
            let array = Array(tariffs?.enumerated() ?? [].enumerated())
            VStack(spacing: 4){
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(array, id: \.element.id) { index, orderInfo in
                            CarSelectionView(item: orderInfo, isSelected: orderInfo == selectedItem)
                                .onTapGesture {
                                    DataHolder.tariffId = tariffs![index].id
                                    selectedItem = orderInfo
                                    if tariffs![index] == DataHolder.selectedTariff {
                                        mainViewModel.showTariffDetailsDialog.toggle()
                                    }
                                    DataHolder.selectedTariff = tariffs![index]
                                   
                                }
                        }
                    }
                    .padding(EdgeInsets(top: 24, leading: 16, bottom: 4, trailing: 16))
                    .frame(maxHeight: 120)
                }
                
                AddressField(mainViewModel: mainViewModel)
                    .padding(.horizontal, 16)
                PaymentAndWishSection(showWishDialog: $showWishDialog)
                    .padding(.horizontal, 16)
                
                let isButtonDisabled = selectedItem == nil
                
                Button(action: {
                    mainViewModel.isShowBonusDialog.toggle()
                }, label: {
                    GGButton(title: "Order")
                })
                .padding(.horizontal, 12)
                .padding(.bottom, 32)
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
                
            }
            .background(Color.white)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            .padding(.top, 12)
            .shadow(radius: 2)
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct AddressField: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var showAddressesDialog = false
    
    var body: some View {
        VStack(spacing: 4, content: {
            HStack{
                Image(systemName: "circle").opacity(0.5)
                if !mainViewModel.locationHolder.isEmpty {
                    Text(mainViewModel.locationHolder[0].addressName)
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(12)
            HStack{
                Image(systemName: "circle").opacity(0.5)
                
                let count = mainViewModel.locationHolder.count
                
                if count == 1{
                    Button {
                        mainViewModel.isSearchDialogShowing = true
                    } label: {
                        Text("Where are we going?")
                            .fontWeight(.medium)
                            .foregroundColor(Color.black.opacity(0.5))
                    }
                    Spacer()
                }else if count == 2 {
                    Text(mainViewModel.locationHolder[1].addressName)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .foregroundColor(Color.black)
                    Spacer()
                    Button(action: {
                        mainViewModel.isSearchDialogShowing = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }else if count > 2 {
                    Button(action: {
                        showAddressesDialog.toggle()
                    }, label: {
                        Text("\(count-1) picked location")
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                            .lineLimit(1)
                    }).sheet(isPresented: $showAddressesDialog){
                        DialogAddressLists(dialogAddressList: $showAddressesDialog, viewModel: mainViewModel)
                    }
                    
                    Spacer()
                    Button(action: {
                        if count < 6 {
                            mainViewModel.isSearchDialogShowing = true
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
            }
            .padding(.vertical, 12)
        })
    }
}

struct PaymentAndWishSection: View {
    @Binding var showWishDialog: Bool
    
    var body: some View {
        VStack {
            Divider()
            HStack(alignment: .center) {
                Image(systemName: "dollarsign.circle")
                    .opacity(0.5)
                Text("Cash")
                Spacer()
                Divider().frame(height: 24)
                Spacer()
                Button(action: {
                    showWishDialog.toggle()
                }) {
                    Image(systemName: "text.aligncenter")
                        .opacity(0.5)
                        .foregroundColor(.black)
                    
                    Text("Wishes")
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showWishDialog) {
                    DialogWish(dialogWish: $showWishDialog)
                }
            }
            
            .padding(.vertical, 8)
        }
    }
}


//struct OrderGoView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderGoView(status: 5)
//    }
//}
