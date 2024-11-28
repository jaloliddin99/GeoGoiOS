//
//  ShimmerViewModifier.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 13/11/24.
//

import SwiftUI

//struct ShimmerViewModifier: ViewModifier {
//    @State private var animationPhase = -1.0
//    
//    func body(content: Content) -> some View {
//        content
//            .mask(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.75), Color.clear]),
//                                 startPoint: .leading, endPoint: .trailing))
//            .overlay(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.75), Color.clear]),
//                                    startPoint: .leading, endPoint: .trailing)
//                .offset(x: animationPhase * UIScreen.main.bounds.width))
//            .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: animationPhase))
//            .onAppear() {
//                animationPhase = 1.0
//            }
//    }
//}
//
//extension View {
//    func shimmering() -> some View {
//        self.modifier(ShimmerViewModifier())
//    }
//}
