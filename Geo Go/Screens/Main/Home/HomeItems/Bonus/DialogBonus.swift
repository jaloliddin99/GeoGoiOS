//
//  DialogBonus.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 26/08/24.
//

import SwiftUI

struct DialogBonus: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var selectedBonusOption: BonusOptions?
    
    var body: some View {
        VStack(spacing: 12) {
            VStack {
                HStack {
                    Text(formatNumberWithSpaces(viewModel.bonusResponse.balance))
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white)
                        
                    
                    Image("menu_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
                if let label = viewModel.discountModel {
                    Text(label.label)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#363640"))
            .cornerRadius(20)
            
            if let discounts = viewModel.discountModel {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(discounts.list, id: \.self) { listItem in
                            BonusNumber(option: listItem, selectedBonusOption: $selectedBonusOption)
                        }
                    }
                }
                .frame(maxHeight: 64)
                .padding(.vertical, 30)
                
                if let selectedOption = selectedBonusOption {
                    Text(selectedOption.title)
                        .font(.system(size: 24, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.txt)
                    
                    Text(selectedOption.description)
                        .font(.system(size: 18, weight: .regular))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.txt.opacity(0.6))
                }
                
                Image("bonus_cash")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding()
            }
            Spacer()
        }
        .padding(16)
        .onAppear{
            if let option = viewModel.discountModel {
                selectedBonusOption = option.list[0]
            }
        }
    }
}

struct BonusNumber: View {
    let option: BonusOptions
    @Binding var selectedBonusOption: BonusOptions?
    var body: some View {
        Button {
            selectedBonusOption = option
        } label: {
            Text(option.count)
                .font(.system(size: 24, weight: .medium))
                .frame(width: 64, height: 64)
                .foregroundColor(.main)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
    }
}
