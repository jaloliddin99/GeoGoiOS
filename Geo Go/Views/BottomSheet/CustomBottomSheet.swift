//
//  CustomBottomSheet.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 09/07/24.
//

import SwiftUI
struct CustomBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            if isPresented {
                VStack {
                    Spacer()
                    
                    VStack {
                        content
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .transition(.move(edge: .bottom))
                }
                .background(Color.black.opacity(0.5)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    withAnimation {
                                        isPresented = false
                                    }
                                })
            }
        }
        .animation(.easeInOut, value: isPresented)
        .edgesIgnoringSafeArea(.all)
    }
}
