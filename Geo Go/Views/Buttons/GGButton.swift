//
//  GGButton.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import SwiftUI

struct GGButton: View {
    var title: LocalizedStringKey
    var textColor: Color = .white
    var bgColor: Color = .main
    
    var body: some View {
        Text(title)
            .font(.system(size: 16))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .foregroundColor(textColor)
            .background(bgColor)
            .cornerRadius(10)
    }
}

#Preview {
    GGButton(title: "Geo Go")
}
