//
//  Options.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 13/07/24.
//

import Foundation

struct OptionsClass: Codable {
    var tariffId: Int64
    var optionName: String
    var optionId: Int64
    var isChecked = false

}

func dataSelect(data: [ServiceTariff]) -> [OptionsClass] {
    var list = [OptionsClass]()
    data.forEach { serviceTariff in
        serviceTariff.options.forEach {
            let optionName = returnTitle(title: $0.name)
            if !optionName.isEmpty {
                list.append(OptionsClass(tariffId: serviceTariff.id, optionName: optionName, optionId: $0.id))
            }
        }
    }
    return list
}

func returnTitle(title: String) -> String {
    guard let lastCharacter = title.last else { return "" }
    switch lastCharacter {
    case "!":
        return "Door to Door"
    case "@":
        return "Turn on the air conditioner"
    case "#":
        return "Smoking lounge"
    case "$":
        return "Battery charging"
    case "%":
        return "Gas should be given"
    case "^":
        return "With USB charger"
    case "&":
        return "Car with luggage needed"
    case "*":
        return "Car with roof luggage needed"
    case "-":
        return "You must deliver alcohol"
    case "/":
        return "There is an extra person"
    default:
        return ""
    }
}

func titleConvertor(stringItem: String, lang: String) -> [TariffDetails] {
    var list = [TariffDetails]()
    var current: String
    
    switch lang {
        case "kaa":
            current = "kr"
        case "ka":
            current = "gr"
        default:
            current = lang
    }
    
    do {
        for i in 1...2 {
            let titleDetails = stringItem.split(separator: "TariffTitleDetails_\(current):\(i)")[1].split(separator: "@")[0]
            let descriptionDetails = stringItem.split(separator: "TariffDescriptionDetails_\(current):\(i)")[1].split(separator: "@")[0]
            
            list.append(TariffDetails(titleDetails: String(titleDetails), descriptionDetails: String(descriptionDetails)))
        }
    } catch {
        print(error)
    }
    return list
}


func convertTariff(lang: String, data: ServiceTariff) -> String {
    var name = ""
    do {
        switch lang {
            case "uz":
                if let uzName = data.name.components(separatedBy: "tariffNameUz:").dropFirst().first?
                    .components(separatedBy: "@").first?
                    .replacingOccurrences(of: "[", with: "") {
                    name = uzName
                }
            case "ru":
                if let ruName = data.name.components(separatedBy: "tariffNameRu:").dropFirst().first?
                    .components(separatedBy: "@").first {
                    name = ruName
                }
            case "ka":
                if let kaName = data.name.components(separatedBy: "tariffNameGr:").dropFirst().first?
                    .components(separatedBy: "@").first {
                    name = kaName
                }
            case "kaa":
                if let kaaName = data.name.components(separatedBy: "tariffNameKr:").dropFirst().first?
                    .components(separatedBy: "@").first {
                    name = kaaName
                }
            case "en":
                if let enName = data.name.components(separatedBy: "tariffNameEn:").dropFirst().first?
                    .components(separatedBy: "@").first {
                    name = enName
                }
            default:
                name = ""
        }
    } catch {
        print("Error extracting tariff name: \(error.localizedDescription)")
    }
    return name
}


struct MyDescriptionModel {
    var title: String
    var section1: String
    var section2: String
    var bonusFirst: String
    var returnBonus: String
    let increaseTitle: String
    let increaseDesc: String
    let dialogDescription: String
}


func description(lang: String, data: ServiceTariff) -> MyDescriptionModel {
    if let description = data.description, !description.isEmpty {
        var titleInfo: Substring = ""
        var tariff1Section: Substring = ""
        var tariff2Section: Substring = ""
        var bonusFirst: Substring = ""
        var bonusReturn: Substring = ""
        var increaseTitle: Substring = ""
        var increaseDesc: Substring = ""
        var dialogDescription: Substring = ""
        
        if data.name.contains("Эконом") || 
            data.name.contains("Перегон") ||
            data.name.contains("Доставка") ||
            data.name.contains("Комфорт")
        {
            do {
                switch lang {
                    case "uz":
                        print("DeSCRIPTIONnnn  \(description)")
                        let parts = description.components(separatedBy: "TitleUz:")
                        titleInfo = Substring(parts[1].components(separatedBy: "@")[0])

                      
                        tariff1Section = description.split(separator: "TariffInfoUz:")[1].split(separator: "@")[0]
                        tariff2Section = description.split(separator: "GrowthUz:")[1].split(separator: "@")[0]
                        bonusFirst = description.split(separator: "Bonus_uz:")[1].split(separator: "@")[0]
                        bonusReturn = description.split(separator: "BonusReturn_uz:")[1].split(separator: "@")[0]
                        if description.contains("increaseTitle") {
                            increaseTitle = description.split(separator: "increaseTitle_Uz:")[1].split(separator: "@")[0]
                            increaseDesc = description.split(separator: "increaseDesc_Uz:")[1].split(separator: "@")[0]
                            dialogDescription = description.split(separator: "increaseDialog_Uz:")[1].split(separator: "@")[0]
                        }
                    case "ru":
                        titleInfo = description.split(separator: "TitleRu:")[1].split(separator: "@")[0]
                        tariff1Section = description.split(separator: "TariffInfoRu:")[1].split(separator: "@")[0]
                        tariff2Section = description.split(separator: "GrowthRu:")[1].split(separator: "@")[0]
                        bonusFirst = description.split(separator: "Bonus_ru:")[1].split(separator: "@")[0]
                        bonusReturn = description.split(separator: "BonusReturn_ru:")[1].split(separator: "@")[0]
                        if description.contains("increaseTitle") {
                            increaseTitle = description.split(separator: "increaseTitle_Ru:")[1].split(separator: "@")[0]
                            increaseDesc = description.split(separator: "increaseDesc_Ru:")[1].split(separator: "@")[0]
                            dialogDescription = description.split(separator: "increaseDialog_Ru:")[1].split(separator: "@")[0]
                        }
                    case "en":
                        titleInfo = description.split(separator: "TitleEn:")[1].split(separator: "@")[0]
                        tariff1Section = description.split(separator: "TariffInfoEn:")[1].split(separator: "@")[0]
                        tariff2Section = description.split(separator: "GrowthEn:")[1].split(separator: "@")[0]
                        bonusFirst = description.split(separator: "Bonus_en:")[1].split(separator: "@")[0]
                        bonusReturn = description.split(separator: "BonusReturn_en:")[1].split(separator: "@")[0]
                        if description.contains("increaseTitle") {
                            increaseTitle = description.split(separator: "increaseTitle_En:")[1].split(separator: "@")[0]
                            increaseDesc = description.split(separator: "increaseDesc_En:")[1].split(separator: "@")[0]
                            dialogDescription = description.split(separator: "increaseDialog_En:")[1].split(separator: "@")[0]
                        }
                    case "kaa":
                        titleInfo = description.split(separator: "TitleKr:")[1].split(separator: "@")[0]
                        tariff1Section = description.split(separator: "TariffInfoKr:")[1].split(separator: "@")[0]
                        tariff2Section = description.split(separator: "GrowthGr:")[1].split(separator: "@")[0]
                        bonusFirst = description.split(separator: "Bonus_kr:")[1].split(separator: "@")[0]
                        bonusReturn = description.split(separator: "BonusReturn_kr:")[1].split(separator: "@")[0]
                        if description.contains("increaseTitle") {
                            increaseTitle = description.split(separator: "increaseTitle_Kr:")[1].split(separator: "@")[0]
                            increaseDesc = description.split(separator: "increaseDesc_Kr:")[1].split(separator: "@")[0]
                            dialogDescription = description.split(separator: "increaseDialog_Kr:")[1].split(separator: "@")[0]
                        }
                    case "ka":
                        titleInfo = description.split(separator: "TitleGr:")[1].split(separator: "@")[0]
                        tariff1Section = description.split(separator: "TariffInfoGr:")[1].split(separator: "@")[0]
                        tariff2Section = description.split(separator: "GrowthGr:")[1].split(separator: "@")[0]
                        bonusFirst = description.split(separator: "Bonus_gr:")[1].split(separator: "@")[0]
                        bonusReturn = description.split(separator: "BonusReturn_gr:")[1].split(separator: "@")[0]
                        if description.contains("increaseTitle") {
                            increaseTitle = description.split(separator: "increaseTitle_Gr:")[1].split(separator: "@")[0]
                            increaseDesc = description.split(separator: "increaseDesc_Gr:")[1].split(separator: "@")[0]
                            dialogDescription = description.split(separator: "increaseDialog_Gr:")[1].split(separator: "@")[0]
                        }
                    default:
                        break
                }
            } catch {
                print("Error Occurred \(error.localizedDescription)")
            }
            return MyDescriptionModel(
                title: String(titleInfo),
                section1: String(tariff1Section),
                section2: String(tariff2Section),
                bonusFirst: String(bonusFirst),
                returnBonus: String(bonusReturn),
                increaseTitle: String(increaseTitle),
                increaseDesc: String(increaseDesc),
                dialogDescription: String(dialogDescription)
            )
        }
        
        // Repeat similar logic for other cases like "Перегон", "Доставка", "Комфорт"
        // Ensure you handle them similar to the "Эконом" case above
        
    }
    
    return MyDescriptionModel(
        title: "",
        section1: "",
        section2: "",
        bonusFirst: "",
        returnBonus: "",
        increaseTitle: "",
        increaseDesc: "",
        dialogDescription: ""
    )
}

