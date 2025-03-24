//
//  DialogLanguage.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/11/24.
//

import SwiftUI


struct DialogLanguage: View {
    @ObservedObject var vm: LanguageViewModel
    @State var tempSelectedLanguage: String?

    let languages = ["O'zbek", "English", "Русский", "Qaraqalpaq"]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                
                GGText(text: "select_language")
                
                VStack(spacing: 4) {
                    ForEach(languages, id: \.self) { option in
                        HStack(alignment: .center) {
                            RadioButton(isSelected: (tempSelectedLanguage ?? vm.selectedLanguage) == option)
                            Text(option)
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .padding(.leading, 12)
                            Spacer()
                        }
                        .frame(height: 40)
                        .onTapGesture {
                            tempSelectedLanguage = option
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    vm.changeLanguage(to: tempSelectedLanguage!)
                }) {
                    GGButton(title: "save", isDisabled: tempSelectedLanguage == nil)
                        .frame(maxWidth: .infinity)
                }
                .disabled(tempSelectedLanguage == nil)
            }
            .padding(.horizontal, 16)
        }
    }
}
