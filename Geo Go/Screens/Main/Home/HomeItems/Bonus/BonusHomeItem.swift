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
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.txt)
            
            Image("menu_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
