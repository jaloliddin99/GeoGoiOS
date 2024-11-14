//
//  LanguageViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/11/24.
//

import Foundation
import SwiftUI

class LanguageViewModel: ObservableObject {
    @Published var showLanguageSheet = false
    @Published var selectedLanguage: String
    @Published var tempSelectedLanguage: String?
    
    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
    }
    
    func saveLanguage() {
        if let newLanguage = tempSelectedLanguage, let languageCode = languageCodes[newLanguage] {
            selectedLanguage = newLanguage
            DataHolder.lang = languageCode
            UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
        showLanguageSheet = false
    }
}

func updateLanguage() {
    let lang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
    DataHolder.lang = languageCodes[lang] ?? "en"
}

var languageCodes: [String: String] = [
    "O'zbek": "uz",
    "English": "en",
    "Русский": "ru",
    "Qaraqalpaq": "kaa"
    ]
