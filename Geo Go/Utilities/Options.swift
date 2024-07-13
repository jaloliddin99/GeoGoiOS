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
