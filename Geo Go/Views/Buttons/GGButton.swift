//
//  GGButton.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import SwiftUI

struct GGButton: View {
    var title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .foregroundColor(.white)
            .background(Color.main)
            .cornerRadius(10)
    }
}

#Preview {
    GGButton(title: "Geo Go")
}
