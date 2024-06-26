//
//  AddNameScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/06/24.
//

import SwiftUI

struct AddNameScreen: View {
    let enter_your_name: LocalizedStringKey = "enter_your_name"
    let whats_your_name: LocalizedStringKey = "what_is_your_name"
    let save: LocalizedStringKey = "save"
    @State private var username: String = ""
    

    var isButtonDisabled: Bool {
        return username.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text(whats_your_name)
                        .font(.system(size: 20))
                        .fontWeight(.regular)

                    TextField(enter_your_name, text: $username)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(9)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                Spacer()

                Button(action: {
                    EnterPhoneScreen(username: username)
                }) {
                    GGButton(title: save)
                }
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(enter_your_name)
            .padding()
        }
    }
}



struct AddNameScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddNameScreen()
    }
}
