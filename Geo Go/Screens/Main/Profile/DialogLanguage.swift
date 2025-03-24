//
//  DialogLanguage.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/11/24.
//

import SwiftUI

struct DialogLanguage: View {
    @ObservedObject var vm: LanguageViewModel = .shared
    @State private var tempSelectedLanguage: String?
    
    let languages = ["O'zbek", "English", "Русский", "Qaraqalpaq"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("select_language".localize())
            
            VStack(spacing: 4) {
                ForEach(languages, id: \.self) { option in
                    HStack {
                        RadioButton(isSelected: (tempSelectedLanguage ?? vm.selectedLanguage) == option)
                        Text(option)
                            .foregroundColor(.black)
                            .padding(.leading, 12)
                        Spacer()
                    }
                    .frame(height: 40)
                    .onTapGesture {
                        tempSelectedLanguage = option
                    }
                }
            }
            
            Button(action: {
                if let selected = tempSelectedLanguage {
                    vm.changeLanguage(to: selected)
                }
            }) {
                Text("save".localize())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(tempSelectedLanguage == nil ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(tempSelectedLanguage == nil)
            .padding(.top, 20)
        }
        .padding()
    }
}
