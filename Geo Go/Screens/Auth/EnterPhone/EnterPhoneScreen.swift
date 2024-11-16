//
//  EnterPhoneScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/06/24.
//

import SwiftUI
import iPhoneNumberField
import PhoneNumberKit

struct EnterPhoneScreen: View {
    var username: String
    
    @StateObject var viewModel = EnterPhoneViewModel()
    
    @State private var phoneNumber: String = ""
    @State private var isChecked: Bool = false
    @State var pn: PhoneNumber?

    var isButtonDisabled: Bool {
        return !(pn != nil && isChecked)
    }
    @State private var actualNumber: String = ""
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                VStack {
                    Text("enter_your_phone")
                        .font(.system(size: 24))
                        .padding(.bottom, 8)
                        .fontWeight(.bold)
                    
                    Text("we_send_code")
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .padding(.bottom, 10)
                    
                    
                    iPhoneNumberField(text: $phoneNumber)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .defaultRegion("UZ")
                        .font(UIFont(size: 24, weight: .bold, design: .rounded))
                        .onNumberChange(perform: { code in
                            if code != nil {
                                pn = code
                            }else{
                                pn = nil
                            }
                        })
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    
                    agreementSection
                }
                
                
                
                Spacer()
                
                Button(action: {
                    guard let pn = pn else { return }
                    actualNumber = "+\(pn.countryCode)\(pn.nationalNumber)"
                    let registrationReq = RegistrationRequest(
                        confirmationType: Constants.CONFIRMATION_TYPE,
                        phone: actualNumber,
                        info: ClientInfo(firstName: username)
                    )
                    viewModel.submitRegistration(regRequest: registrationReq)
                }) {
                    GGButton(title: "get_code")
                }
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
                .navigationDestination(isPresented: Binding<Bool>(
                    get: { viewModel.postData != nil },
                    set: { _ in }
                )) {
                    if let postData = viewModel.postData {
                        EnterCodeScreen(userId: postData.id, phoneNumber: actualNumber)
                    }
                }
                
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
         

            
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .alert(item: $viewModel.alertItem){ alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton
            )
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
