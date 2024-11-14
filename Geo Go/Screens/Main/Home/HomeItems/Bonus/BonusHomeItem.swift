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
            Text(formatNumberWithSpaces(viewModel.bonusResponse.balance))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.txt)
            
            Image("menu_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }
        .frame(maxHeight: 56, alignment: .center)
        .padding(.horizontal, 12)
        .background(.white)
        .cornerRadius(28)
        .shadow(radius: 2)
    }
}
