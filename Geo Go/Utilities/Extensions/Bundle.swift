//
//  Bundle.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/11/24.
//

import Foundation

extension Bundle {
    private static var bundle: Bundle!
    
    static func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            print("Failed to find path for language: \(language)")
            return
        }
        
        guard let langBundle = Bundle(path: path) else {
            print("Failed to load bundle for language: \(language)")
            return
        }
        
        Self.bundle = langBundle
    }
    
    static func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return bundle?.localizedString(forKey: key, value: value, table: tableName) ?? NSLocalizedString(key, value: value ?? <#default value#>, table: tableName, comment: <#String#>)
    }
}
