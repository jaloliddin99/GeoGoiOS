//
//  DefaultContentView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 12/11/24.
//

import SwiftUI

struct DefaultContentView: View {
    
    @ObservedObject var viewModel: MainViewModel

    
    var body: some View {
        ZStack{
            drawerAndBonusButton()
            locationButton
            BottomSheetView(isOpen: $viewModel.bottomSheetShown,
                            minHeight: 250,
                            maxHeight: UIScreen.main.bounds.height) {
                BottomSheetContent(viewModel: viewModel)
            }.edgesIgnoringSafeArea(.bottom)
                .shadow(color: .black.opacity(0.1),radius: 16)

        }
    }

    var locationButton: some View {
        Button(action: {
            viewModel.findUserRealPosition(loc: viewModel.location)
        }) {
            DrawerBtn(name: "location_btn", fromAssets: true, color: .txt)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 262)
        .shadow(color: .black.opacity(0.1),radius: 16)

        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .ignoresSafeArea()
    }
    
    private func drawerAndBonusButton() -> some View {
        HStack{
            Button(action: {
                withAnimation {
                    viewModel.isDrawerOpen.toggle()
                }
            }) {
                DrawerBtn(name: "menu_navigation", fromAssets: true)
            }
            .shadow(color: .black.opacity(0.1),radius: 16)

            Spacer()
            Button(action: {
                viewModel.serviceTariffRequest()
                viewModel.showBonusDialog.toggle()
            }, label: {
                BonusHomeItem(viewModel: viewModel)
            })

        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    
    
    
}
