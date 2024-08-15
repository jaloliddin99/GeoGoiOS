//
//  DrawerBtn.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import SwiftUI

struct DrawerBtn: View {
    var body: some View {
        Image("menu_navigation")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(12)
            .frame(width: 56, height: 56)
            .background(Circle()
                .fill(Color.white)
                .shadow(radius: 2))
           
    }
}

struct RadioButton: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Image(systemName: isSelected ? "circle.fill" : "circle")
            .resizable()
            .foregroundColor(.main)
            .frame(width: 24, height: 24)
            .onTapGesture {
                action()
            }
    }
}

#Preview {
    RadioButton(isSelected: false, action: {})
}

#Preview {
    DrawerBtn()
}
