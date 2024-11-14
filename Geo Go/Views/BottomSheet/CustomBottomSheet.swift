//
//  CustomBottomSheet.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 09/07/24.
//

import SwiftUI


struct BottomSheet<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0){
            Rectangle()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray)
                .cornerRadius(10)
                .padding(.top, 20)
            content
            Spacer()
        }
    }
}
