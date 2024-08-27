//
//  Bonus.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 27/07/24.
//

import Foundation


struct BonusResponse: Codable {
    let balance: Double
    let capabilities: Capabilities
}

struct Capabilities: Codable {
    var type: String
    var min: Double
    var max: Double
    var options: [Double]?
}



struct BonusOptions: Hashable {
    let count: String
    let title: String
    let description: String
    let tag: Int
}

struct DiscountModel {
    let list: [BonusOptions]
    let label: String
}

func optionBonus(serviceResponse: ServiceResponse, lang: String) -> DiscountModel {
    if let tariffs = serviceResponse.tariffs {
        for serviceTariff in tariffs {
            if serviceTariff.name.starts(with: "tariffNameUz:Ekonom@tariffNameRu:Эконом@tariffNameKr:Ekonom@tariffNameEn:Econom@") {
                if let description = serviceTariff.description {
                    return convertor(stringList: description, lang: lang)
                }
            }
        }
    }
    return DiscountModel(list: [], label: "")
}

func convertor(stringList: String, lang: String) -> DiscountModel {
    var list = [BonusOptions]()
    let langCount: String
    switch lang {
        case "uz":
            langCount = "Uz"
        case "ru":
            langCount = "Ru"
        case "en":
            langCount = "En"
        case "kaa":
            langCount = "Kr"
        case "ka":
            langCount = "Gr"
        default:
            langCount = "Uz"
    }
    
    for i in 1...5 {
        if stringList.contains("BonusTitle\(langCount):\(i)") {
            let title = stringList.split(separator: "BonusTitle\(langCount):\(i)")[1].split(separator: "@")[0]
            let description = stringList.split(separator: "BonusDescription\(langCount):\(i)")[1].split(separator: "@")[0]
            list.append(BonusOptions(count: String(i), title: String(title), description: String(description), tag: i))
        }
    }
    
    var label = ""
    switch lang {
        case "uz":
            label = String(stringList.split(separator: "BonusLabelUz:")[1].split(separator: "@")[0])
        case "ru":
            label = String(stringList.split(separator: "BonusLabelRu:")[1].split(separator: "@")[0])
        case "en":
            label = String(stringList.split(separator: "BonusLabelEn:")[1].split(separator: "@")[0])
        case "kaa":
            label = String(stringList.split(separator: "BonusLabelKr:")[1].split(separator: "@")[0])
        case "ka":
            label = String(stringList.split(separator: "BonusLabelGr:")[1].split(separator: "@")[0])
        default:
            break
    }
    
    return DiscountModel(list: list, label: label)
}
