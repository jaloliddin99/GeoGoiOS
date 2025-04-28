//
//  CustomThumbSlider.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//


import SwiftUI
import UIKit



struct CarProgressSlider: View {
    let value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 6)
                
                Capsule()
                    .fill(Color.blue)
                    .frame(
                        width: geometry.size.width - CGFloat(value / 100) * geometry.size.width,
                        height: 6
                    )
                    .alignmentGuide(.leading) { _ in 0 }
                    .offset(x: CGFloat(value / 100) * geometry.size.width)

                Image("car_from_above_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(90))
                    .offset(x: max(0, CGFloat(value / 100) * geometry.size.width - 16), y: 0)
            }
            .frame(height: 40)
        }
    }
}
