//
//  CarSelectionView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/07/24.
//

import SwiftUI
import Lottie
import UIKit
import Shimmer

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
                    
                    if !item.showEstimation {
                        Text(convertTariff(lang: DataHolder.lang, data: item))
                            .font(.system(size: 14, weight: .semibold))
                            .frame(alignment: .leading)
                        
                    } else {
                        Text(convertTariff(lang: DataHolder.lang, data: item))
                            .font(.system(size: 14, weight: .semibold))
                            .frame(alignment: .leading)
                            .shimmer()
                    }
                    
                    
                    HStack(spacing: 0) {
                        if !item.showEstimation {
                            HStack(alignment: .bottom,spacing: 4){
                                if shouldShowFromText {
                                    fromText
                                }
                                
                                Text(String(Int(item.minCost)))
                                    .customStyle()
                                
                                Text(getCurrencySymbol())
                                    .customStyle(font: .regular, size: 14)
                                
                                if shouldShowFromTextForOtherLang {
                                    fromText.font(.system(size: 14, weight: .regular))
                                }
                            }
                        }else{
                            HStack(alignment: .bottom,spacing: 4){
                                if shouldShowFromText {
                                    fromText
                                        .shimmer()
                                }
                                
                                Text(String(Int(item.minCost)))
                                    .customStyle()
                                    .shimmer()
                                
                                Text(getCurrencySymbol())
                                    .customStyle(font: .regular, size: 14)
                                    .shimmer()
                                
                                if shouldShowFromTextForOtherLang {
                                    fromText.font(.system(size: 14, weight: .regular))
                                        .shimmer()
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
                .padding(.leading, isSelected ? 6 : 0)
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
                .padding(.leading, isSelected ? 0 : -8)
                .clipped()
            
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
    
    private var shouldShowFromText: Bool {
        DataHolder.lang == "ru" || DataHolder.lang == "en"
    }
    
    private var shouldShowFromTextForOtherLang: Bool {
        DataHolder.lang == "uz" || DataHolder.lang == "kaa"
    }
    
    private var fromText: some View {
        Text(LocalizedStringKey("from"))
            .customStyle()
    }

}



extension View {
    func customStyle(font: Font.Weight = .semibold, size: CGFloat = 17) -> some View {
        self.font(.system(size: size, weight: font))
            .foregroundColor(.txt)
    }
    
    func shimmer() -> some View {
        self.shimmering(
            animation:.easeInOut(duration: 0.7).repeatCount(5, autoreverses: false).delay(0.05)
        )
    }
}

