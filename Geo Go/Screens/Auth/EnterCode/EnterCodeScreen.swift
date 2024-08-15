//  EnterCodeScreen.swift
//  Geo Go
//
//  Created by macbook pro on 27/06/24.
//

import SwiftUI
import OTPView

struct EnterCodeScreen: View {
    

    let userId: Int
    let phoneNumber: String

    @StateObject var viewModel = EnterCodeViewModel()

    @State private var code:String=""
    
    var isButtonDisabled: Bool {
        return code.count != 4
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack{
                    Text("enter_sms_code")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    
                    Text(formattedString)
                    
                    OtpView(activeIndicatorColor: Color.black,
                            inactiveIndicatorColor: Color.gray,
                            length: 4,
                            doSomething: { value in
                        code = value
                    })
                    
                }
                Spacer()
                
                Button(action: {
                    viewModel.getAppetizer(id: String(userId), code: code)
                }) {
                    GGButton(title: "send")
                }
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .alert(item: $viewModel.alertItem){ alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton
                )
            }
            .navigationDestination(isPresented: Binding<Bool>(
                get: { viewModel.response != nil },
                set: { _ in }
            )) {
                if viewModel.response != nil {
                    HomeScreen()
                }
            }
            onAppear{
                UserDefaults.standard.setValue(phoneNumber, forKey: Constants.USER_PHONE)
            }
            
        }
        
    }
    
    var formattedString: String {
        let localizedString = NSLocalizedString("enter_sms_code_desc", comment: "")
        return String(format: localizedString, phoneNumber)
    }
}


#Preview {
    EnterCodeScreen(userId: 12, phoneNumber: "hello")
}
