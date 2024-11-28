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


struct MapConfig {
    func removeRoute(mapView: MapView) {
        do {
            let layers = mapView.mapboxMap.allLayerIdentifiers
            for layer in layers {
                if let source = mapView.mapboxMap.layerProperty(for: layer.id, property: "source").value as? String,
                   source == "line-source" {
                    try mapView.mapboxMap.removeLayer(withId: layer.id)
                }
            }
            
            if mapView.mapboxMap.sourceExists(withId: "line-source") {
                try mapView.mapboxMap.removeSource(withId: "line-source")
            }
            let pointSourceId = "point-source"
            let pointLayerId = "point-layer"
            
            if mapView.mapboxMap.sourceExists(withId: pointSourceId) {
                try? mapView.mapboxMap.removeSource(withId: pointSourceId)
            }
            if mapView.mapboxMap.layerExists(withId: pointLayerId) {
                try? mapView.mapboxMap.removeLayer(withId: pointLayerId)
            }
            
        } catch {
            print("Failed to remove source/layer from map: \(error)")
        }
    }
}
