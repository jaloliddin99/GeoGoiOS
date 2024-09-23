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
        VStack(spacing: 12){
            Spacer()
            HStack{
                Button(action: {
                    mainViewModel.retainFirstElement()
                    mainViewModel.setStatus(value: 0)
                }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.main)
                        .padding(12)
                        .frame(width: 48, height: 48)
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
        HStack(alignment: .center,spacing: 8) {
            Image("route_image")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 64)
            
            VStack(spacing: 12) {
                if !mainViewModel.locationHolder.isEmpty {
                    Text(mainViewModel.locationHolder[0].addressName)
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                
                Divider()
                
                HStack{
                    let count = mainViewModel.locationHolder.count
                    if count == 1{
                        Button {
                            mainViewModel.isSearchDialogShowing = true
                        } label: {
                            Text("Where are we going?")
                                .fontWeight(.medium)
                                .foregroundColor(.black.opacity(0.5))
                        }
                        Spacer()
                    }else if count == 2 {
                        Text(mainViewModel.locationHolder[1].addressName)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .foregroundColor(.txt)
                        Spacer()
                        Button(action: {
                            mainViewModel.isSearchDialogShowing = true
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundColor(.main)
                        })
                    }else if count > 2 {
                        Button(action: {
                            showAddressesDialog.toggle()
                        }, label: {
                            Text("\(count-1) picked location")
                                .fontWeight(.medium)
                                .foregroundColor(.txt)
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
                                .foregroundColor(.main)
                        })
                    }
                }
            }
    
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(.secondarySystemBackground).opacity(0.7))
        )
    }
}




struct PaymentAndWishSection: View {
    @Binding var showWishDialog: Bool
    @State var paymentMethod: String = getPaymentMethod()
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                
                NavigationLink(destination: PaymentScreen(paymentMethod: $paymentMethod)) {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.main)
                    
                    Text(paymentMethod == "cash" ? "Cash" : "Card" )
                        .foregroundColor(.txt)
                }
                
                
                Spacer()
                Divider().frame(height: 24)
                Spacer()
                Button(action: {
                    showWishDialog.toggle()
                }) {
                    Image(systemName: "text.aligncenter")
                        .foregroundColor(.main)
                    
                    Text("Wishes")
                        .foregroundColor(.txt)
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
