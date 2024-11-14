//
//  AddCardScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 17/09/24.
//

import SwiftUI
import OTPView



struct AddCardScreen: View {
    
    @State private var cardName: String = ""
    @State private var cardNumber: String = ""
    @State private var expiryDate = ""
    @State private var otpCode: String = ""
    @StateObject var viewModel = ViewModelAddCard()

    @State private var isCardInit: Bool = true
    @Environment(\.dismiss) var dismiss

    var isButtonDisabled: Bool {
        if isCardInit {
            return cardName.isEmpty || cardNumber.count != 16 || expiryDate.count != 4
        }else{
            return otpCode.count != 6
        }
    }

    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 0){
                Text("enter_card_details")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.txt)
                    .padding(.top, 24)
                
                
                Text("card_name")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .padding(.top, 16)
                
                TextField("for_example", text: $cardName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: cardName) {
                        if cardName.count > 30 {
                            cardName = String(cardName.prefix(16))
                        }
                    }
                    .padding(.top, 6)
                
                Text("card_number")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .padding(.top, 16)
                
                TextField("card_number_camel", text: $cardNumber)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
                    .onChange(of: cardNumber) {
                        if cardNumber.count > 16 {
                            cardNumber = String(cardNumber.prefix(16))
                        }
                    }
                    .padding(.top, 6)
                
                Text("expire_date")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    
                    .padding(.top, 16)
                
                
                TextField("MMYY", text: $expiryDate)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
                    .onChange(of: expiryDate) {
                        if expiryDate.count > 4 {
                            expiryDate = String(expiryDate.prefix(4))
                        }
                    }
                    .frame(maxWidth: 90)
                    .padding(.top, 6)
                
                if !isCardInit {
                    Text("enter_code")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .padding(.top, 16)
                    
                    OTPField($otpCode)
                        .padding(.top, 6)
                }
                
                Spacer()
                
                Button(action: {
                    if isCardInit {
                        let firstPart = expiryDate.prefix(2)
                        let secondPart = expiryDate.suffix(2)
                        
                        let formattedString = secondPart + firstPart


                        let body = ModelAddCard(
                            card_number: cardNumber,
                            expiry: String(formattedString),
                            userId: getUserPhone()
                        )
                        viewModel.addCardRequest(body: body)
                    }else{
                        if let resBody = viewModel.addCardResponse {
                            let body = ModelConfirmCard(
                                otp: otpCode, 
                                transaction_id: resBody.transaction_id!,
                                userId: getUserPhone(),
                                card_name: cardName,
                                id: String(resBody.id!)
                            )
                            viewModel.confirmCardRequest(body: body)
                        }
                    }
                }) {
                    GGButton(title: "send")
                }
                .disabled(isButtonDisabled)
                .opacity(isButtonDisabled ? 0.5 : 1.0)
                
            }
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("add_card")
        .background(.white)
        .padding(16)
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $viewModel.alertItem){ alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton
            )
        }
        .onReceive(viewModel.$addCardResponse) { response in
            if response != nil {
                isCardInit = false
            }
        }
        .onReceive(viewModel.$confirmCardResponse) { response in
            if response != nil {
                dismiss()
            }
        }
        
    }
    
    

}

