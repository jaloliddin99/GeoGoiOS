//
//  MapConfig.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import Foundation
import SwiftUI

@_spi(Experimental) import MapboxMaps

struct OrnamentConfigurations {
    static let hiddenLogoOptions: LogoViewOptions = {
        LogoViewOptions(
            position: .topLeft,
            margins: CGPoint(x: -1000, y: -1000)
        )
    }()
    
    static let hiddenAttributionButtonOptions: AttributionButtonOptions = {
        AttributionButtonOptions(
            position: .topLeft,
            margins: CGPoint(x: -1000, y: -1000)
        )
    }()
    
    static let defaultOrnamentOptions: OrnamentOptions = {
        OrnamentOptions(
            scaleBar: ScaleBarViewOptions(visibility: .hidden),
            logo: hiddenLogoOptions,
            attributionButton: hiddenAttributionButtonOptions
        )
    }()
}
