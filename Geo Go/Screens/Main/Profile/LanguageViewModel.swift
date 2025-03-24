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
    
    static let shared = LanguageViewModel()
    
    @Published var locale: Locale = Locale(identifier: Locale.current.identifier)

    
    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
    }
    
    func changeLanguage(to newLanguage: String) {
        selectedLanguage = newLanguage

        let languageCode = languagesToCodes[newLanguage]!
        DataHolder.lang = languageCode

        UserDefaults.standard.set(newLanguage, forKey: "selectedLanguage")
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        locale = Locale(identifier: languageCode)
        NotificationCenter.default.post(name: NSLocale.currentLocaleDidChangeNotification, object: nil)
        
        showLanguageSheet = false
        
    }

    
    
    @EnvironmentObject var restartManager: AppRestartManager
  
}


func updateLanguage() {
    let lang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
    DataHolder.lang = languagesToCodes[lang] ?? "en"
}

var languagesToCodes: [String: String] = [
    "O'zbek": "uz",
    "English": "en",
    "Русский": "ru",
    "Qaraqalpaq": "kaa"
    ]

var languageCodesToLang: [String: String] = [
    "uz": "O'zbek",
    "en": "English",
    "ru": "Русский",
    "kaa": "Qaraqalpaq"
]

