//
//  CarSelectionView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/07/24.
//

import SwiftUI
import Lottie
import UIKit

struct CarSelectionView: View {
    let item: ServiceTariff
    var isSelected: Bool
    let animation: Namespace.ID
    let action: () -> Void

    var body: some View {
        
        Button(action: action) {
            
            let hasExtra = item.Type == "add" || item.Type == "multiply"
            ZStack{
               
                VStack(alignment: .leading, spacing: 0) {
                    carAndMinView()
                    
                    Text(convertTariff(lang: DataHolder.lang, data: item))
                        .font(.system(size: 14, weight: .semibold))
                        .frame(alignment: .leading)
                    
                    HStack(spacing: 0) {
                        if !item.showEstimation {
                            HStack(alignment: .bottom,spacing: 4){
                                if DataHolder.lang == "ru" || DataHolder.lang == "en" {
                                    Text(LocalizedStringKey("from"))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.txt)
                                }
                                Text(String(Int(item.minCost)))
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.txt)
                                
                                Text(getCurrencySymbol())
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.txt)
                                if DataHolder.lang == "uz" || DataHolder.lang == "kaa" {
                                    Text(LocalizedStringKey("from"))
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.txt)
                                }
                            }
                        }else{
                            ProgressView(value: 0.5)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.main))
                                .frame(width: 20, height: 20)
                                .padding(.leading, 4)
                        }
                    }
                }
                .padding(.vertical, 4)
                .padding(.leading, 6)
                .padding(.trailing, hasExtra ? 44 : 40)
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.15))
                                .matchedGeometryEffect(id: "background", in: animation)
                        }
                    }
                )
                .foregroundColor(isSelected ? .txt : .gray)
                .padding(.top, 6)
                
                
                
                HStack(spacing: 4){
                    if item.costChangeStep2 ?? 0.0 > 0.0 && isSelected {
                        LottieEmptyStateView(fileName: "swipe_right")
                            .frame(width: 10, height: 12)
                            .rotationEffect(.degrees(-90))
                    }
                    
                    if hasExtra {
                        if let bonus = item.costChangeStep2 {
                            Text("\(Int(bonus))".replacing(" ", with: ""))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.clear)
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: isSelected ? [.blue, .purple]
                                                           : [.gray, .gray]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(
                                        Text("\(Int(bonus))".replacing(" ", with: ""))
                                            .font(.system(size: 14, weight: .medium))
                                    )
                                )
                        }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(.white)
                .cornerRadius(12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                
            }
            .frame(height: 84)
            
        }

        
    }
    
    func carAndMinView() -> some View {
        
        ZStack(alignment: .leading){
            Image(imageNameForType(item.icon))
                .resizable()
                .frame(width: 95, height: 40)
                .opacity(isSelected ? 1 : 0.3)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let minTime = item.minArriveTime, minTime != -1 {
                let minuteText = NSLocalizedString("min", comment: "")
                Text("\(minTime) \(minuteText)")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(isSelected ? .txt : .gray)
                    .padding(.horizontal, 3)
                    .padding(.vertical, 1.5)
                    .background(.white)
                    .cornerRadius(4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    
            }
        }
        
    }

}

