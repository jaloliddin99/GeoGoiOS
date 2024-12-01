//
//  ShimmerViewModifier.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 13/11/24.
//

import SwiftUI
import SwiftUI
//
//struct ShimmerModifier: ViewModifier {
//    @State private var phase: CGFloat = 0
//    
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//                .opacity(0.5) // Base content with reduced opacity
//            LinearGradient(
//                gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.3), Color.clear]),
//                startPoint: .leading,
//                endPoint: .trailing
//            )
//            .rotationEffect(.degrees(30))
//            .offset(x: phase * 200 - 100)
//            .mask(content) // Apply the gradient only to the content
//        }
//        .onAppear {
//            withAnimation(
//                Animation.linear(duration: 1.5)
//                    .repeatForever(autoreverses: false)
//            ) {
//                phase = 1
//            }
//        }
//    }
//}
//
//extension View {
//    func shimmer() -> some View {
//        self.modifier(ShimmerModifier())
//    }
//}
