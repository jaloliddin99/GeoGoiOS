//
//  MapStyle.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import Foundation
import SwiftUI

@_spi(Experimental) import MapboxMaps


extension MapStyle {
  static let lightStyle = MapStyle(uri: StyleURI(rawValue: "mapbox://styles/uzdriver/cl0j7klhe001415o8wpkop805")!)
    
    static let darkStyle = MapStyle(uri: StyleURI(rawValue: "mapbox://styles/uzdriver/cl27vz2fr004e15jz7sx0vvc5")!)
}
