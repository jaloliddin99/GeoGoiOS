//
//  DialogWish.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 13/07/24.
//

import SwiftUI

struct DialogWish: View {
    @Binding var dialogWish: Bool
    @State var lists = DataHolder.listOptions
    
    @State private var showCommentDialog = false
    @State private var showAnotherUserDialog = false

    @State private var comment: String = ""
    @State private var namePhone: UserNameAndPhone? = nil

    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Form{
                
                Section(header: Text("Wish")){
                    WishListItem(title: "Comment", subTitle: comment, action: {
                        showCommentDialog.toggle()
                        DataHolder.globalComment = comment
                    })
                    .sheet(isPresented: $showCommentDialog){
                        DialogComment(showCommentDialog: $showCommentDialog, commentSend: $comment)
                    }
                
                    
                    WishListItem(title: "With Kids", action: {
                        
                    })
                    
                    let subTitle = namePhone == nil ? "" : "\(namePhone!.name) | \(namePhone!.phone)"
                    WishListItem(title: "Order another person", subTitle: subTitle, action: {
                        showAnotherUserDialog.toggle()
                    })
                    
                    .sheet(isPresented: $showAnotherUserDialog, content: {
                        DialogAnotherPerson(showOtherPersonDialog: $showAnotherUserDialog, userNameAndPhone: $namePhone)
                    })
                }
                Section(header: Text("OPTIONS")){
                    ForEach($lists, id: \.optionId) { $list in
                        Toggle(list.optionName, isOn: $list.isChecked)
                    }
                }
                
                Section {
                    Toggle("Select all", sources: $lists, isOn: \.isChecked)
                }
            }
            
            Spacer()
            
            Button(action: {
                dialogWish.toggle()
            }, label: {
                GGButton(title: "save")
            })
            .padding(.horizontal, 12)
        }
    }
}

struct WishListItem: View {
    var title: String
    var subTitle: String = ""
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack{
                VStack(alignment: .leading){
                    Text(title)
                        .foregroundColor(.black)
                    
                    if !subTitle.isEmpty {
                        Text(subTitle)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.5))
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.forward")
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(.horizontal, 12)
        }
        .contentShape(Rectangle())
    }
}



struct DialogWish_Previews: PreviewProvider {
    @State static var dialogWish = true
    
    static var previews: some View {
        DialogWish(dialogWish: $dialogWish)
    }
}


