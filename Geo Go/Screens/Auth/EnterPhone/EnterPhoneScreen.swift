//
//  EnterPhoneScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/06/24.
//

import SwiftUI
import iPhoneNumberField

struct EnterPhoneScreen: View {
    var username: String
    
    @State private var phoneNumber: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var isChecked: Bool = false
    
    var isButtonDisabled: Bool {
        return username.isEmpty
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    Text("enter_your_phone")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    Text("we_send_code")
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .padding(.top, 6)
                        .padding(.bottom, 10)
                    
                    iPhoneNumberField(text: $phoneNumber)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .font(UIFont(size: 24, weight: .bold, design: .rounded))
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    agreementSection
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    GGButton(title: "get_code")
                }
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
    
    private var agreementSection: some View {
        HStack(alignment: .center) {
            Button(action: {
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
            }
            .buttonStyle(PlainButtonStyle())
            
            agreementText
        }
        .font(.body)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    private func linkedText(_ key: String, url: String) ->  Text {
        Text(LocalizedStringKey(key))
            .underline()
            .foregroundColor(.blue)
        //            .onTapGesture {
        //                openURL(URL(string: url)!)
        //            }
    }
    
    private var agreementText: some View {
        Group {
            Text(LocalizedStringKey("terms_prefix"))
            + linkedText("user_agreement", url: "https://www.example.com/user-agreement")
            + Text(LocalizedStringKey("terms_and"))
            + linkedText("privacy_policy", url: "https://www.example.com/privacy-policy")
        }
    }
    
    private func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

#Preview {
    EnterPhoneScreen(username: "Tom")
}
