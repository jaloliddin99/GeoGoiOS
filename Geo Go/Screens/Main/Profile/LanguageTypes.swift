//
//  LanguageTypes.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 24/03/25.
//


enum LanguageTypes: String, CaseIterable, RawRepresentable {
    case uzbek = "uz"
    case english = "en"
    case russian = "ru"
    case karakalpak = "kaa"
    
    var name: String {
        switch self {
            case .uzbek: return "O'zbekcha"
            case .english: return "English"
            case .russian: return "Русский"
            case .karakalpak: return "Qoraqalpoq"
        }
    }
}
