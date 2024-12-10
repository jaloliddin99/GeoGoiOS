//
//  DrawerBtn.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import SwiftUI

struct DrawerBtn: View {
    let name: String
    var fromAssets: Bool
    var color = Color.main
    
    var body: some View {
        if fromAssets {
            Image(name)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(color)
                .aspectRatio(contentMode: .fit)
                .padding(10)
                .frame(width: 48, height: 48)
                .background(Circle().fill(Color.white))
                .shadow(color: .black.opacity(0.1),radius: 16)

        } else {
            Image(systemName: name)
                .resizable()
                .foregroundColor(color)
                .aspectRatio(contentMode: .fit)
                .padding(12)
                .frame(width: 48, height: 48)
                .background(Circle()
                    .fill(Color.white))
                .shadow(color: .black.opacity(0.1),radius: 16)

        }
           
    }
}

struct RadioButton: View {
    let isSelected: Bool
    var color: Color = .main
    var body: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .resizable()
            .foregroundColor(color)
            .frame(width: 28, height: 28)
    }
}


#Preview {
    DrawerBtn(name: "location", fromAssets: true)
}
