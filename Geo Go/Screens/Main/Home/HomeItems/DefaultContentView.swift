//
//  DefaultContentView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 12/11/24.
//

import SwiftUI

struct DefaultContentView: View {
    
    @Binding var markerOffset: CGFloat
    @ObservedObject var viewModel: MainViewModel

    
    var body: some View {
        MarkerView(markerOffset: $markerOffset, viewModel: viewModel)
            .offset(y: markerOffset)
            .animation(.easeInOut, value: markerOffset)
        
        locationButton
        BottomSheetView(isOpen: $viewModel.bottomSheetShown,
                        minHeight: 250,
                        maxHeight: UIScreen.main.bounds.height) {
            BottomSheetContent(viewModel: viewModel)
        }.edgesIgnoringSafeArea(.bottom)
    }

    private var locationButton: some View {
        Button(action: {
            viewModel.findUserRealPosition(loc: viewModel.location,  offset: markerOffset)
        }) {
            DrawerBtn(name: "location.fill", fromAssets: false, color: .txt)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 262)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .ignoresSafeArea()
    }
    
    
    
}
