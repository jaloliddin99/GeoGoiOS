//
//  OrderGoView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/07/24.
//

import SwiftUI
import Shimmer

struct OrderGoView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var showWishDialog = false
    @State private var selectedItem: ServiceTariff?
    @State private var selectedTab: Int = 0
    @State private var isButtonDisabled: Bool = true

    @Namespace private var animation
    
    @State private var topBarHeight: CGFloat = 0
    @State private var mainContentHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            topBar
            mainContent()
        }
        .onReceive(mainViewModel.$tariff) { updateSelectedItem(from: $0) }
        .ignoresSafeArea()
    }
    
    private var topBar: some View {
        HStack {
            Button(action: {
                isButtonDisabled = true
                mainViewModel.setStatus(value: 0)
                mainViewModel.retainFirstElement()
            }) {
                DrawerBtn(name: "left-arrow", fromAssets: true, color: .txt)
            }
            Spacer()
            locationButton
        }
        .padding(.horizontal, 12)
    }
    
    private func mainContent() -> some View {
        let tariffs = mainViewModel.tariff?.tariffs
        let array = Array(tariffs?.enumerated() ?? [].enumerated())
        
        return VStack(spacing: 4) {
            carSelectionSection(array: array, tariffs: tariffs)
            AddressField(mainViewModel: mainViewModel)
                .padding(.horizontal, 16)
            PaymentAndWishSection(showWishDialog: $showWishDialog)
                .padding(.horizontal, 16)
            orderButton
        }
        .background(Color.white)
        .cornerRadius(12, corners: [.topLeft, .topRight])
        .padding(.top, 12)
        .shadow(radius: 2)
    }
    
    private func carSelectionSection(array: [(offset: Int, element: ServiceTariff)],
                                     tariffs: [ServiceTariff]?) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(array, id: \.element.id) { index, orderInfo in
                        CarSelectionView(item: orderInfo, isSelected: selectedTab == index, animation: animation) {
                            handleCarSelection(index: index, orderInfo: orderInfo, tariffs: tariffs, proxy: proxy)
                        }.id(index)
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Order Button
    private var orderButton: some View {
        Button(action: {
            mainViewModel.isShowBonusDialog.toggle()
        }) {
            GGButton(title: isButtonDisabled ? "no_available_car" : "order",
                     isDisabled: isButtonDisabled)
        }
        .disabled(isButtonDisabled)
        .padding(.horizontal, 12)
        .padding(.bottom, 32)
        .opacity(isButtonDisabled ? 0.5 : 1.0)
    }
    
    // MARK: - Helper Functions
    private func handleCarSelection(index: Int, orderInfo: ServiceTariff, tariffs: [ServiceTariff]?, proxy: ScrollViewProxy) {
        withAnimation(.easeInOut) {
            selectedTab = index
            proxy.scrollTo(index, anchor: .center)
        }
        guard let tariffs = tariffs else { return }
        let tariff = tariffs[index]
        DataHolder.tariffId = tariff.id
        selectedItem = orderInfo
        
        updateButtonState()
        
        if tariffs[index] == DataHolder.selectedTariff {
            mainViewModel.showTariffDetailsDialog.toggle()
        }
        DataHolder.selectedTariff = tariff
        let name = convertTariff(lang: DataHolder.lang, data: tariff)
        UserDefaults.standard.set(name, forKey: Constants.TARIFF)
        UserDefaults.standard.set(tariff.icon, forKey: Constants.TARIFF_ICON)
    }
    
    private func updateButtonState() {
        if let selectedItem {
            if selectedItem.minArriveTime == nil || selectedItem.minArriveTime == -1 {
                isButtonDisabled = true
            }else{
                isButtonDisabled = false
            }
        }else{
            isButtonDisabled = true
        }
    }
    
    private func updateSelectedItem(from result: ServiceResponse?) {
        guard let tariffs = result?.tariffs, !tariffs.isEmpty else { return }
        selectedItem = tariffs.first
        updateButtonState()
        let name = convertTariff(lang: DataHolder.lang, data: selectedItem!)
        UserDefaults.standard.set(name, forKey: Constants.TARIFF)
        UserDefaults.standard.set(selectedItem!.icon, forKey: Constants.TARIFF_ICON)
        
    }
    
    var locationButton: some View {
        Button(action: {
            mainViewModel.findUserRealPosition(loc: mainViewModel.location)
        }) {
            DrawerBtn(name: "location.fill", fromAssets: false, color: .txt)
        }
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
                            
                            HStack(alignment: .center){
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black.opacity(0.7))
                                
                                Text("txt_where_to_go")
                                    .fontWeight(.medium)
                                    .foregroundColor(.black.opacity(0.7))
                                
                                Spacer()
                            }
                            
                        }
                        Spacer()
                    }else if count == 2 {
                        Text(mainViewModel.locationHolder[1].addressName)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .foregroundColor(.txt)
                        
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
                    
                    Text(paymentMethod == "cash" ? "cash" : "card" )
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
                    
                    Text("wishes")
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
