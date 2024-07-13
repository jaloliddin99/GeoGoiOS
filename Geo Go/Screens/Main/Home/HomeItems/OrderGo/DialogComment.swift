//
//  DialogComment.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 13/07/24.
//

import SwiftUI

struct DialogComment: View {
    @Binding var showCommentDialog: Bool
    @Binding var commentSend: String

    @State private var comment: String = ""
    var isButtonDisabled: Bool {
        return comment.count < 4
    }
    
   
    var body: some View {
        
        VStack(alignment: .leading){
            Text("Enter comment for driver!")
                .font(.title)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 24, leading: 12, bottom: 12, trailing: 12))
               
            
            TextField("Be Quick...", text: $comment)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 200, alignment: .topLeading)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 12)

            
            Spacer()
            Button(action: {
                commentSend = comment
                showCommentDialog.toggle()
            }, label: {
                GGButton(title: "Save")
            })
            .disabled(isButtonDisabled)
            .opacity(isButtonDisabled ? 0.5 : 1.0)
            .padding()
        }
        .presentationDetents([.medium])
    }
}


struct DialogComment_Previews: PreviewProvider {
    @State static var dialogWish = true
    @State static var commentSend: String = "hello"

    static var previews: some View {
        DialogComment(showCommentDialog: $dialogWish, commentSend: $commentSend)
    }
}
