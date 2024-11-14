//
//  DialogLanguage.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/11/24.
//

import SwiftUI

struct DialogLanguage: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    let languages = ["O'zbek", "English", "Русский", "Qaraqalpaq"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(languages, id: \.self) { language in
                    HStack {
                        Text(language)
                        Spacer()
                        if language == languageViewModel.tempSelectedLanguage ?? languageViewModel.selectedLanguage {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        languageViewModel.tempSelectedLanguage = language
                    }
                }
            }
            .navigationBarItems(trailing: Button("Save") {
                languageViewModel.saveLanguage()
            })
            .navigationBarTitle("Select Language", displayMode: .inline)
        }
    }
}
