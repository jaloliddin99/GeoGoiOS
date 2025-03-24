//
//  LanguageViewModel.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/11/24.
//
import Foundation
import SwiftUI

final class LanguageViewModel: ObservableObject {
    @Published var showLanguageSheet = false
    @Published var selectedLanguage: String
    
    static let shared = LanguageViewModel()
    
    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
        Bundle.setLanguage(language: languagesToCodes[selectedLanguage] ?? "en")
    }
    
    func changeLanguage(to newLanguage: String) {
        selectedLanguage = newLanguage
        let languageCode = languagesToCodes[newLanguage] ?? "en"
        
        Bundle.setLanguage(language: languageCode)
        
        UserDefaults.standard.set(newLanguage, forKey: "selectedLanguage")
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        
        DataHolder.lang = languageCode
        UserDefaults.standard.synchronize()
        showLanguageSheet = false
    }
    
    func changeLanguageFromCode(to languageCode: String) {
        let newLanguage = codesToLanguages[languageCode] ?? "English"
        selectedLanguage = newLanguage
        //let languageCode = languagesToCodes[newLanguage] ?? "en"
        
        Bundle.setLanguage(language: languageCode)
        
        print("language code \(languageCode), new Language is \(newLanguage)")
        
        UserDefaults.standard.set(newLanguage, forKey: "selectedLanguage")
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        
        DataHolder.lang = languageCode
        UserDefaults.standard.synchronize()
        showLanguageSheet = false
    }
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



var codesToLanguages: [String: String] = [
    "uz": "O'zbek",
    "en": "English",
    "ru": "Русский",
    "kaa": "Qaraqalpaq"
]


