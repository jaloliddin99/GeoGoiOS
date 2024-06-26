//
//  EnterPhoneScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/06/24.
//

import SwiftUI

struct EnterPhoneScreen: View {
    var username: String
    
    let enter_your_phone: LocalizedStringKey = "enter_your_phone"
    //let enter_your_phone: LocalizedStringKey = "enter_your_phone"
    let get_code: LocalizedStringKey = "get_code"
    
    @State private var phoneNumber: String = ""
    @Environment(\.dismiss) var dismiss
    
    
    var isButtonDisabled: Bool {
        return username.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                VStack() {
                    Text(enter_your_phone)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    Text(enter_your_phone)
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    
                    TextField(enter_your_phone, text: $phoneNumber)
                    
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                       

                    
                }
                Spacer()
                
                Button(action: {
                    
                }) {
                    GGButton(title: get_code)
                }
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Enter Phone")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .padding()
        }
     
    }
}

#Preview {
    EnterPhoneScreen(username: "Tom")
}
