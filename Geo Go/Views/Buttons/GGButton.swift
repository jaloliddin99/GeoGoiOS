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
    var isDisabled: Bool = false 
    var body: some View {
        Text(title)
            .font(.system(size: 16))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .foregroundColor(textColor)
            .background(isDisabled ? Color.gray.opacity(0.7) : bgColor)            .cornerRadius(10)
    }
}


#Preview {
    GGButton(title: "Geo Go")
}
