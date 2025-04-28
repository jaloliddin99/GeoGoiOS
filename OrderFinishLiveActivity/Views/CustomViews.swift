//
//  CustomViews.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 26/04/25.
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

struct CommentAndIndex{
    let comment: String
    let star: Int
}

import SwiftUI
struct GGButton: View {
    var title: String
    var textColor: Color = .white
    var bgColor: Color = .main
    var isDisabled: Bool = false
    var body: some View {
        Text(LocalizedStringKey(title.localize()))
            .font(.system(size: 16))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .foregroundColor(textColor)
            .background(isDisabled ? Color.gray.opacity(0.7) : bgColor)            .cornerRadius(10)
    }
}


#Preview {
    GGText(text: "Text")
}
