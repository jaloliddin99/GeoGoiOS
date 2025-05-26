//
//  CarAnimationManager.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/05/25.
//

import SwiftUI
import Combine
import MapboxMaps
import Turf
import CoreLocation
import UIKit

// Car Animation Manager to be used within SwiftUI's UIViewRepresentable
class CarAnimationManager {
    private var mapView: MapView
    private var driverAnimations: [String: CADisplayLink] = [:]
    private var carPositions: [String: CarPosition] = [:]
    
    // Car position struct to track current position and animation data
    struct CarPosition {
        var currentCoordinate: CLLocationCoordinate2D
        var originCoordinate: CLLocationCoordinate2D?
        var destinationCoordinate: CLLocationCoordinate2D?
        var bearing: Double
        var type: String
        var animationStartTimestamp: CFTimeInterval?
    }
    
    // Constants
    enum Constants {
        static let CAR_ICON_ID = "car_icon"
        static let CAR_ICON_SOURCE_ID = "car_source"
        static let CAR_ICON_LAYER_ID = "car_layer"
        static let ANIMATION_DURATION: CFTimeInterval = 2.0
    }
    
    init(mapView: MapView) {
        self.mapView = mapView
    }
    
    deinit {
        // Invalidate all animations when manager is deallocated
        for (_, displayLink) in driverAnimations {
            displayLink.invalidate()
        }
    }
    
    func updateCarMarkers(driverList: [SDriverData]) {
        let newDriverIds = Set(driverList.map { $0.driverId })
        
        // Get the set of currently tracked driver IDs
        let currentDriverIds = Set(carPositions.keys)
        
        // Drivers to remove (in current list but not in new list)
        let driversToRemove = currentDriverIds.subtracting(newDriverIds)
        
        // Drivers to add (in new list but not in current list)
        let driversToAdd = newDriverIds.subtracting(currentDriverIds)
        
        // Drivers to update (present in both lists)
        let driversToUpdate = newDriverIds.intersection(currentDriverIds)
        
        // Remove drivers that are no longer in the list
        for driverId in driversToRemove {
            removeDriver(driverId: driverId)
        }
        
        // Process new driver data
        for driver in driverList {
            if driversToAdd.contains(driver.driverId) {
                // Add new drivers
                addDriver(driver: driver)
            } else if driversToUpdate.contains(driver.driverId) {
                // Update existing drivers with animation
                updateDriverPosition(driver: driver)
            }
        }
        
        // Update the GeoJSON source with current positions
        updateGeoJSONSource()
    }
    
    private func addDriver(driver: SDriverData) {
        // Create the initial car marker without animation
        let coordinate = CLLocationCoordinate2D(latitude: driver.lat, longitude: driver.long)
        
        // If this is the first car, ensure the icon is added
        if carPositions.isEmpty, let image = UIImage(named: "car_from_above") {
            try? mapView.mapboxMap.addImage(image, id: Constants.CAR_ICON_ID)
            
            // Create source and layer if they don't exist yet
            createSourceAndLayer()
        }
        
        // Add to tracked positions
        carPositions[driver.driverId] = CarPosition(
            currentCoordinate: coordinate,
            originCoordinate: nil,
            destinationCoordinate: nil,
            bearing: driver.bearing,
            type: driver.type,
            animationStartTimestamp: nil
        )
    }
    
    private func removeDriver(driverId: String) {
        // Stop any ongoing animation for this driver
        if let displayLink = driverAnimations[driverId] {
            displayLink.invalidate()
            driverAnimations.removeValue(forKey: driverId)
        }
        
        // Remove from tracked positions
        carPositions.removeValue(forKey: driverId)
        
        // If no more cars, remove the layer and source
        if carPositions.isEmpty {
            removeCarIconsFromMap()
        }
    }
    
    // Class to hold driver ID for display link
    private class AnimationContext {
        let driverId: String
        
        init(driverId: String) {
            self.driverId = driverId
        }
    }
    
    private func updateDriverPosition(driver: SDriverData) {
        let newCoordinate = CLLocationCoordinate2D(latitude: driver.lat, longitude: driver.long)
        
        // Get current position
        guard var carPosition = carPositions[driver.driverId] else { return }
        
        // Cancel existing animation if any
        if let displayLink = driverAnimations[driver.driverId] {
            displayLink.invalidate()
            driverAnimations.removeValue(forKey: driver.driverId)
        }
        
        // Set up animation data
        carPosition.originCoordinate = carPosition.currentCoordinate
        carPosition.destinationCoordinate = newCoordinate
        carPosition.bearing = driver.bearing
        carPosition.type = driver.type
        carPosition.animationStartTimestamp = CACurrentMediaTime()
        
        // Store updated position
        carPositions[driver.driverId] = carPosition
        
        // Create a context object with the driver ID
        let context = AnimationContext(driverId: driver.driverId)
        
        // Create display link for animation and pass context as the target
        let displayLink = CADisplayLink(target: self, selector: #selector(updateDriverAnimation(displayLink:)))
        
        // Store the context object so it's retained
        objc_setAssociatedObject(displayLink, &AssociatedObjectKey.driverIdContext, context, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        displayLink.add(to: .current, forMode: .common)
        driverAnimations[driver.driverId] = displayLink
    }
    
    // Associated object key for storing context
    private struct AssociatedObjectKey {
        static var driverIdContext = "driverIdContext"
    }
    
    @objc fileprivate func updateDriverAnimation(displayLink: CADisplayLink) {
        // Get the animation context with driver ID
        guard let context = objc_getAssociatedObject(displayLink, &AssociatedObjectKey.driverIdContext) as? AnimationContext,
              let driverId = context.driverId as String?,
              var carPosition = carPositions[driverId],
              let origin = carPosition.originCoordinate,
              let destination = carPosition.destinationCoordinate,
              let startTime = carPosition.animationStartTimestamp else {
            displayLink.invalidate()
            // We can't properly clean up the dictionary entry without the driver ID
            // but the display link will be invalidated at least
            return
        }
        
        let animationProgress = (CACurrentMediaTime() - startTime) / Constants.ANIMATION_DURATION
        
        // If animation is complete
        if animationProgress >= 1.0 {
            carPosition.currentCoordinate = destination
            carPosition.originCoordinate = nil
            carPosition.destinationCoordinate = nil
            carPosition.animationStartTimestamp = nil
            
            carPositions[driverId] = carPosition
            
            // End animation
            displayLink.invalidate()
            driverAnimations.removeValue(forKey: driverId)
        } else {
            // Interpolate between origin and destination
            let latitude = origin.latitude + (destination.latitude - origin.latitude) * animationProgress
            let longitude = origin.longitude + (destination.longitude - origin.longitude) * animationProgress
            
            carPosition.currentCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            carPositions[driverId] = carPosition
        }
        
        // Update the GeoJSON source with interpolated positions
        updateGeoJSONSource()
    }
    
    private func updateGeoJSONSource() {
        let features: [Feature] = carPositions.map { (driverId, position) in
            var feature = Feature(geometry: .point(Point(position.currentCoordinate)))
            feature.properties = [
                "driverId": .string(driverId),
                "bearing": .number(position.bearing),
                "type": .string(position.type)
            ]
            return feature
        }
        
        let featureCollection = FeatureCollection(features: features)
        
        let sourceId = Constants.CAR_ICON_SOURCE_ID
        let layerId = Constants.CAR_ICON_LAYER_ID
        let lineLayerId = "line-layer"
        
        if !mapView.mapboxMap.sourceExists(withId: sourceId) {
            createSourceAndLayer()
        } else {
            // Update source
            mapView.mapboxMap.updateGeoJSONSource(
                withId: sourceId,
                geoJSON: .featureCollection(featureCollection)
            )
            
            // Check if line-layer exists and if car-icon-layer is not below it, then move it
            if mapView.mapboxMap.layerExists(withId: lineLayerId),
               mapView.mapboxMap.layerExists(withId: layerId) {
                do {
                    try mapView.mapboxMap.moveLayer(withId: layerId, to: .above(lineLayerId))
                } catch {
                    print("Error repositioning car icon layer: \(error)")
                }
            }
        }
    }


    
    private func createSourceAndLayer() {
        
        if !mapView.mapboxMap.sourceExists(withId: Constants.CAR_ICON_SOURCE_ID) {
            var source = GeoJSONSource(id: Constants.CAR_ICON_SOURCE_ID)
            source.data = .featureCollection(FeatureCollection(features: []))
            try? mapView.mapboxMap.addSource(source)
        }
        
        if !mapView.mapboxMap.layerExists(withId: Constants.CAR_ICON_LAYER_ID) {
            var layer = SymbolLayer(id: Constants.CAR_ICON_LAYER_ID, source: Constants.CAR_ICON_SOURCE_ID)
            layer.iconImage = .constant(.name(Constants.CAR_ICON_ID))
            layer.iconSize = .constant(0.08)
            layer.iconAllowOverlap = .constant(true)
            layer.iconIgnorePlacement = .constant(true)
            layer.iconRotationAlignment = .constant(.map)
            layer.iconRotate = .expression(Exp(.get) { "bearing" })
            
            let lineLayerId = "line-layer"
            
            do {
                if mapView.mapboxMap.layerExists(withId: lineLayerId) {
                    try mapView.mapboxMap.addLayer(layer, layerPosition: .above(lineLayerId))
                } else {
                    try mapView.mapboxMap.addLayer(layer)
                }
            } catch {
                print("Error adding source or layer: \(error)")
            }
        }
    }
    
    func removeCarIconsFromMap() {
        if mapView.mapboxMap.layerExists(withId: Constants.CAR_ICON_LAYER_ID) {
            try? mapView.mapboxMap.removeLayer(withId: Constants.CAR_ICON_LAYER_ID)
        }
        
        if mapView.mapboxMap.sourceExists(withId: Constants.CAR_ICON_SOURCE_ID) {
            try? mapView.mapboxMap.removeSource(withId: Constants.CAR_ICON_SOURCE_ID)
        }
    }
}
