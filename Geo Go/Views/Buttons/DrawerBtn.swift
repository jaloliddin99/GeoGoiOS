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

#Preview {
    DrawerBtn()
}
