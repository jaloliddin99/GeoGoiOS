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
                .padding(8)
                .frame(width: 48, height: 48)
                .background(Circle()
                    .fill(Color.white)
                    .shadow(radius: 2))
        } else {
            Image(systemName: name)
                .resizable()
                .foregroundColor(.main)
                .aspectRatio(contentMode: .fit)
                .padding(12)
                .frame(width: 48, height: 48)
                .background(Circle()
                    .fill(Color.white)
                    .shadow(radius: 2))
        }
           
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
    DrawerBtn(name: "location", fromAssets: true)
}
