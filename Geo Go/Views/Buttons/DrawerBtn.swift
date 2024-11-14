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
    var body: some View {
        if fromAssets {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(10)
                .frame(width: 56, height: 56)
                .background(Circle()
                    .fill(Color.white)
                    .shadow(radius: 2))
        } else {
            Image(systemName: name)
                .resizable()
                .foregroundColor(.main)
                .aspectRatio(contentMode: .fit)
                .padding(12)
                .frame(width: 56, height: 56)
                .background(Circle()
                    .fill(Color.white)
                    .shadow(radius: 2))
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
