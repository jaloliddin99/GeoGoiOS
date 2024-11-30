//
//  BonusHomeItem.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 26/08/24.
//

import SwiftUI

struct BonusHomeItem: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        HStack{
            Text(formatNumberWtCurrency(viewModel.bonusResponse.balance))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.txt)
            
            Image("menu_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
        }
        .frame(maxHeight: 48, alignment: .center)
        .padding(.horizontal, 12)
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}
