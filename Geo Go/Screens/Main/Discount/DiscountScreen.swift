//
//  DiscountScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/08/24.
//

import SwiftUI

struct DiscountScreen: View {
    
    
    @StateObject var viewModel = DiscountVm()
    @State private var selectedTab: PromoCodeTabTab = .promoCodes
   
    var body: some View {
        ZStack {
            
            
            VStack {
                PromoCodeTabBar(selectedTab: $selectedTab)
                if selectedTab == .promoCodes {
                    PromoCodeScreen(viewModel: viewModel)
                } else {
                    DiscountInnerScreen(viewModel: viewModel)
                }
                Spacer()
            }
            .blur(radius: viewModel.isShowingPopup ? 20 : 0 )

        
            if viewModel.isLoading {
                LoadingView()
            }
                
            

            if viewModel.isShowingPopup {
                PromoCodePopup(viewModel: viewModel)
            }


        }
        .background(.white)
        .navigationTitle("My Trips")
        .navigationBarTitleDisplayMode(.inline)
        .padding(16)
        .alert(item: $viewModel.alertItem){ alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton
            )
        }
        .onAppear{
            viewModel.getPromoCodes()
            viewModel.getDiscounts()
        }

       
    }
    
}

struct DiscountInnerScreen: View {
    @ObservedObject var viewModel: DiscountVm
    var body: some View {
        VStack{
            
            let list = viewModel.getDiscountsResponse ?? []
            
            
            if list.isEmpty {
                Spacer()
                LottieEmptyStateView(fileName: "empty_list")
                    .frame(width: 120, height: 120)
            }else{
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 6) {
                        ForEach(list) { news in
                            NewsItem(newsDate: news, isDiscount: true)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct PromoCodeScreen: View {
    @ObservedObject var viewModel: DiscountVm
    var body: some View {
        
        
        ZStack{
            VStack {
                
                let list = viewModel.getPromoCodeResponse?.data.content ?? []
                
                if list.isEmpty {
                    Spacer()
                    LottieEmptyStateView(fileName: "empty_list")
                        .frame(width: 120, height: 120)
                    
                }else{
                    PromoCodeList(contents: viewModel.getPromoCodeResponse?.data.content ?? [])
                }
                Spacer()
                
                Button {
                    viewModel.isShowingPopup.toggle()
                } label: {
                    GGButton(title: "Enter Promocode")
                }
            }
        }
        
        
        
        
    }
}

struct PromoCodeList: View {
    let contents: [Content]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(contents, id: \.self) { content in
                    PromoCodeItem(content: content)
                }
            }
        }
    }
}

struct PromoCodeTabBar: View {
    @Binding var selectedTab: PromoCodeTabTab
    
    var body: some View {
        HStack {
            ForEach(PromoCodeTabTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    Text(tab.rawValue)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == tab ? .blue : .clear)
                        .foregroundColor(selectedTab == tab ? .white : .black)
                        .cornerRadius(12)
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}


struct PromoCodeItem: View {
    let content: Content
    var body: some View {
        HStack{
            Image("promo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50)
            
            VStack(alignment: .leading){
                Text(formatNumberWithSpaces(Double(content.promocode_amount) ?? 0.0))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.txt)
                Spacer()
                
                Text(convertISOToCustomFormat(isoDate: content.createdAt))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.txt)
                
            }
            Spacer()
            
            Image(systemName: "checkmark")
                .foregroundColor(.green)
            
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color(.secondarySystemBackground).opacity(0.7))
        .cornerRadius(12)
        
        
    }
}


struct PromoCodePopup: View {
    @ObservedObject var viewModel: DiscountVm
    
    @State var promoCodeText: String = ""
    
    var isButtonDisabled: Bool {
         return promoCodeText.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Promocode")
                .font(.headline)
            
            
            TextField("Promocode", text: $promoCodeText)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(9)
                .autocapitalization(.none)
                .disableAutocorrection(true)
           
            HStack {
                Button {
                    viewModel.isShowingPopup = false
                } label: {
                    GGButton(title: "Cancel", bgColor: Color.gray.opacity(0.5))
                        .frame(maxHeight: 40)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    viewModel.isShowingPopup = false
                    viewModel.postPromoCode(body: PromoCodeSend(value: promoCodeText))
                    
                } label: {
                    GGButton(title: "Submit")
                        .frame(maxHeight: 40)
                }
                .frame(maxWidth: .infinity)
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 20)
        .padding(40)
    }
}



enum PromoCodeTabTab: String, CaseIterable {
    case promoCodes = "Promo Codes"
    case actions = "Actions"
}
