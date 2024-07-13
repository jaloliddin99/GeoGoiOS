//
//  DialogAnotherPerson.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 13/07/24.
//

import SwiftUI
import iPhoneNumberField
import PhoneNumberKit



struct UserNameAndPhone{
    let name: String
    let phone: String
}

struct DialogAnotherPerson: View {
    
    @Binding var showOtherPersonDialog: Bool
    @Binding var userNameAndPhone: UserNameAndPhone?
    
    
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var pn: PhoneNumber?

    var isButtonDisabled: Bool {
        return name.count < 3 || pn == nil
    }
    
    var body: some View {
        
        VStack(alignment: .leading){
            Text("Enter Another Person!")
                .font(.title)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 24, leading: 12, bottom: 12, trailing: 12))
               
            
            TextField("Toshmat", text: $name)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 12)

            iPhoneNumberField(text: $phone)
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
                .padding(.horizontal, 12)

            
            
            Spacer()
            Button(action: {
                userNameAndPhone = UserNameAndPhone(name: name, phone: phone)
                showOtherPersonDialog.toggle()
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
