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
            Text("enter_comment")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 24)
                .padding(.bottom, 12)
            CommentField(comment: $comment, hint: "comment_hint_be_quick")
            Spacer()
            Button(action: {
                commentSend = comment
                showCommentDialog.toggle()
            }, label: {
                GGButton(title: "save")
            })
            .disabled(isButtonDisabled)
            .opacity(isButtonDisabled ? 0.5 : 1.0)
            
        }
        .padding(.horizontal, 16)
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
