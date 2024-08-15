//
//  FinishOrder.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct DialogRateDriver: View {
    
    @Binding var invokeDialog: Bool
    let onActionCommited: (CommentAndIndex) -> Void
    @State private var comment: String = ""
    var isButtonDisabled: Bool {
        return comment.count < 4
    }
    
    var body: some View {
        VStack{
            DialogToolBar(showDialog: $invokeDialog, title: "Order Completed")
            Text("Total Fare")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 12)
            
            
            Text("12 000 uzs")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 12)
            
           Line()
             .padding(.horizontal, 32)
             .padding(.vertical, 12)
           
            
            Text("Rate Driver")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 12)
            
            StarRating(rating: .constant(5), maxRating: 5) { newRating in
                print("New rating: \(newRating)")
            }
            .font(.title2)
            .padding(.vertical, 12)
            
            CommentField(comment: $comment, hint: "Good Driver")
            
            Spacer()
            Button(action: {
                onActionCommited(CommentAndIndex(comment: comment, star: 5))
                invokeDialog.toggle()
            }, label: {
                GGButton(title: "Send")
            })
            .disabled(isButtonDisabled)
            .opacity(isButtonDisabled ? 0.5 : 1.0)
        
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
        .edgesIgnoringSafeArea(.bottom)

    }
}

struct CommentAndIndex{
    let comment: String
    let star: Int
}

struct DialogRateDriver_Previews: PreviewProvider {
    @State static var showCommentDialog = false
    let onActionCommited: (CommentAndIndex) -> Void

    static var previews: some View {
        DialogRateDriver(invokeDialog: $showCommentDialog, onActionCommited: { onActionCommited in
            
        })
            .previewLayout(.sizeThatFits)
    }
}

