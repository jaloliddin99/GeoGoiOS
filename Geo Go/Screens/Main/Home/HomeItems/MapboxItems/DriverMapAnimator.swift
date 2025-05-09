//
//  DriverMapAnimator.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/05/25.
//

import MapboxMaps
import UIKit

class DriverMapAnimator {
    private var currentDrivers: [String: SDriverData] = [:]
    private var displayLink: CADisplayLink?
    private var animationStartTime: CFTimeInterval = 0
    private var animationDuration: CFTimeInterval = 0.5
    private var fromDrivers: [String: SDriverData] = [:]
    private var toDrivers: [String: SDriverData] = [:]
    private weak var mapView: MapView?
    
    func updateCarMarkers(mapView: MapView, driverList: [SDriverData]) {
        self.mapView = mapView
        
        // Ensure car icon exists
        if let image = UIImage(named: "car_from_above") {
            try? mapView.mapboxMap.addImage(image, id: Constants.CAR_ICON_ID)
        }
        
        // Ensure source and layer exist
        createSourceAndLayerIfNeeded(mapView: mapView)
        
        // Create new driver dictionary
        let newDriversDictionary = Dictionary(uniqueKeysWithValues: driverList.map { ($0.driverId, $0) })
        
        // Identify updated drivers
        let driversToUpdate = Set(newDriversDictionary.keys).intersection(Set(currentDrivers.keys))
        
        // Prepare interpolation
        fromDrivers = currentDrivers
        toDrivers = newDriversDictionary
        currentDrivers = newDriversDictionary
        
        animationStartTime = CACurrentMediaTime()
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimationFrame))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateAnimationFrame() {
        guard let mapView = mapView else { return }
        
        let elapsed = CACurrentMediaTime() - animationStartTime
        let progress = min(elapsed / animationDuration, 1.0)
        
        var features: [Feature] = []
        
        for (driverId, newDriver) in toDrivers {
            let oldDriver = fromDrivers[driverId]
            
            let startLat = oldDriver?.lat ?? newDriver.lat
            let startLng = oldDriver?.long ?? newDriver.long
            let endLat = newDriver.lat
            let endLng = newDriver.long
            
            let interpolatedLat = startLat + (endLat - startLat) * progress
            let interpolatedLng = startLng + (endLng - startLng) * progress
            
            var feature = Feature(geometry: .point(Point(CLLocationCoordinate2D(latitude: interpolatedLat, longitude: interpolatedLng))))
            feature.properties = [
                "driverId": .string(newDriver.driverId),
                "bearing": .number(newDriver.bearing),
                "type": .string(newDriver.type)
            ]
            features.append(feature)
        }
        
        let featureCollection = FeatureCollection(features: features)
        try? mapView.mapboxMap.updateGeoJSONSource(
            withId: Constants.CAR_ICON_SOURCE_ID,
            geoJSON: .featureCollection(featureCollection)
        )
        
        if progress >= 1.0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    private func createSourceAndLayerIfNeeded(mapView: MapView) {
        if !mapView.mapboxMap.sourceExists(withId: Constants.CAR_ICON_SOURCE_ID) {
            var source = GeoJSONSource(id: Constants.CAR_ICON_SOURCE_ID)
            source.data = .featureCollection(FeatureCollection(features: []))
            try? mapView.mapboxMap.addSource(source)
            
            if !mapView.mapboxMap.layerExists(withId: Constants.CAR_ICON_LAYER_ID) {
                var layer = SymbolLayer(id: Constants.CAR_ICON_LAYER_ID, source: Constants.CAR_ICON_SOURCE_ID)
                layer.iconImage = .constant(.name(Constants.CAR_ICON_ID))
                layer.iconSize = .constant(0.08)
                layer.iconAllowOverlap = .constant(true)
                layer.iconIgnorePlacement = .constant(true)
                layer.iconRotationAlignment = .constant(.map)
                layer.iconRotate = .expression(Exp(.get) { "bearing" })
                try? mapView.mapboxMap.addLayer(layer)
            }
        }
    }
}
