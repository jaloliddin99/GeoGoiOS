//
//  DialogLanguage.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/11/24.
//

import SwiftUI
struct DialogLanguage: View {
    @ObservedObject var vm: LanguageViewModel
    let languages = ["O'zbek", "English", "Русский", "Qaraqalpaq"]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                
                GGText(text: "select_language")

                
                
                VStack(spacing: 4) {
                    ForEach(languages, id: \.self) { option in
                        HStack(alignment: .center) {
                            RadioButton(isSelected: (vm.tempSelectedLanguage ?? vm.selectedLanguage) == option)
                            Text(option)
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .padding(.leading, 12)
                            Spacer()
                        }
                        .frame(height: 40)
                        .onTapGesture {
                            vm.tempSelectedLanguage = option
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    vm.saveLanguage()
                }) {
                    GGButton(title: "save", isDisabled: vm.tempSelectedLanguage == nil)
                        .frame(maxWidth: .infinity)
                }
                .disabled(vm.tempSelectedLanguage == nil)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct DialogLanguage_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = LanguageViewModel()
        mockViewModel.tempSelectedLanguage = "O'zbek"
        
        return DialogLanguage(vm: mockViewModel)
    }
}
