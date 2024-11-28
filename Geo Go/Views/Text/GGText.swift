//
//  GGText.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct GGText: View {
    
    let text: String
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.black)
    }
}


struct CommentField: View {
    @Binding var comment: String
    let hint: String
    var body: some View {
        TextField(LocalizedStringKey(hint), text: $comment)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .topLeading)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }
}

#Preview {
    GGText(text: "Text")
}
