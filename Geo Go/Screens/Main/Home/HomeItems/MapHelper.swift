//
//  MapHelper.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 17/12/24.
//

import SwiftUI
import Combine
@_spi(Experimental) import MapboxMaps
import Turf
import CoreLocation


func drawRoute(_ mapView: MapView, _ coordinates: [MyPoint]) {
    let sourceId = "line-source"
    let lineCoordinates = coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    let lineFeature = Feature(geometry: .lineString(LineString(lineCoordinates)))
    if mapView.mapboxMap.sourceExists(withId: sourceId) {
        do {
            if let _ = try? mapView.mapboxMap.source(withId: sourceId) as? GeoJSONSource {
                mapView.mapboxMap.updateGeoJSONSource(withId: sourceId, geoJSON: .feature(lineFeature))
            } else {
                try? mapView.mapboxMap.removeLayer(withId: "line-layer")
                try? mapView.mapboxMap.removeSource(withId: sourceId)
                createNewRouteSource(mapView, sourceId, lineFeature)
            }
        }
    } else {
        createNewRouteSource(mapView, sourceId, lineFeature)
    }
}

private func createNewRouteSource(_ mapView: MapView, _ sourceId: String, _ lineFeature: Feature) {
    var lineSource = GeoJSONSource(id: sourceId)
    lineSource.data = .feature(lineFeature)
    lineSource.lineMetrics = true
    
    var lineLayer = LineLayer(id: "line-layer", source: sourceId)
    lineLayer.lineColor = .constant(StyleColor(.main))

    
    let lowZoomWidth = 6
    let highZoomWidth = 6
    lineLayer.lineWidth = .expression(
        Exp(.interpolate) {
            Exp(.linear)
            Exp(.zoom)
            14
            lowZoomWidth
            18
            highZoomWidth
        }
    )
    lineLayer.lineCap = .constant(.round)
    lineLayer.lineJoin = .constant(.round)
    
    let layer = (DataHolder.status == 1 || DataHolder.status == 5) ? Constants.DEST_ICON_LAYER_ID : Constants.CLIENT_ICON_LAYER_ID
    
    do {
        try mapView.mapboxMap.addSource(lineSource)
        try mapView.mapboxMap.addLayer(lineLayer, layerPosition: .below(layer))
    } catch {
        print("Error adding source or layer: \(error)")
    }
}
func setCameraBounds(
    _ mapView: MapView,
    _ coordinates: [MyPoint]
){
    if !coordinates.isEmpty {
        let coor = coordinates.map { point in
            CLLocationCoordinate2DMake(point.latitude, point.longitude)
        }
        let referenceCamera = CameraOptions()
        guard let camera = try? mapView.mapboxMap.camera(
            for: coor,
            camera: referenceCamera,
            coordinatesPadding: UIEdgeInsets(top: 100, left: 50, bottom: 300, right: 50),
            maxZoom: nil,
            offset: nil) else { return }
        mapView.camera.fly(to: camera, duration: 0.5)
    }
}


func addViewAnnotation(coordinate: CLLocationCoordinate2D, mapView: MapView) {
    let annotationView = AnnotationView(number: String(5), text: "Min")
    let annotation = ViewAnnotation(
        coordinate: coordinate,
        view: annotationView
    )
    mapView.viewAnnotations.add(annotation)
}



func addCircleLayers(mapView: MapView, userLocations: [Feature]){
    removeCircleLayers(mapView: mapView)
    let pointSourceId = "point-source"
    let pointLayerId = "point-layer"
    
    var pointSource = GeoJSONSource(id: pointSourceId)
    pointSource.data = .featureCollection(FeatureCollection(features: userLocations))
    
    var pointLayer = CircleLayer(id: pointLayerId, source: pointSourceId)
    pointLayer.circleColor = .constant(StyleColor(.white))
    pointLayer.circleRadius = .constant(5)
    pointLayer.circleStrokeWidth = .constant(3.0)
    pointLayer.circleStrokeColor = .constant(StyleColor(.black))
    
    if mapView.mapboxMap.sourceExists(withId: pointSourceId) {
        try? mapView.mapboxMap.removeSource(withId: pointSourceId)
    }
    if mapView.mapboxMap.layerExists(withId: pointLayerId) {
        try? mapView.mapboxMap.removeLayer(withId: pointLayerId)
    }
    
    try! mapView.mapboxMap.addSource(pointSource)
    try! mapView.mapboxMap.addLayer(pointLayer, layerPosition: nil)
}


func updateCarMarkerLocation(_ mapView: MapView, point: MyPoint, bearing: Float64) {
    let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
    var updatedFeature = Feature(geometry: .point(Point(coordinate)))
    
    updatedFeature.properties = [
        "bearing": .number(bearing)
    ]
    
    if mapView.mapboxMap.sourceExists(withId: Constants.CAR_ICON_SOURCE_ID) {
        do {
            let source = try mapView.mapboxMap.source(withId: Constants.CAR_ICON_SOURCE_ID) as? GeoJSONSource
            if source != nil {
                mapView.mapboxMap.updateGeoJSONSource(
                    withId: Constants.CAR_ICON_SOURCE_ID,
                    geoJSON: .feature(updatedFeature)
                )
            } else {
                addCarMarkerAnnotation(mapView: mapView, point: point, bearing: bearing)
            }
        } catch {
            addCarMarkerAnnotation(mapView: mapView, point: point, bearing: bearing)
        }
    } else {
        addCarMarkerAnnotation(mapView: mapView, point: point, bearing: bearing)
    }
}

private func addCarMarkerAnnotation(mapView: MapView, point: MyPoint, bearing: Float64 = 0.0) {
    removeCarMarkerAnnotation(mapView: mapView)
    
    if let carImage = UIImage(named: "car_from_above") {
        do {
            try mapView.mapboxMap.addImage(carImage, id: Constants.CAR_ICON_ID)
        } catch {}
    } else {
        return
    }
    
    let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
    var feature = Feature(geometry: .point(Point(coordinate)))
    feature.properties = [
        "bearing": .number(bearing)
    ]
    
    var source = GeoJSONSource(id: Constants.CAR_ICON_SOURCE_ID)
    source.data = .feature(feature)
    
    do {
        try mapView.mapboxMap.addSource(source)
    } catch {
        return
    }
    

    var layer = SymbolLayer(id: Constants.CAR_ICON_LAYER_ID, source: Constants.CAR_ICON_SOURCE_ID)
    layer.iconImage = .constant(.name(Constants.CAR_ICON_ID))
    layer.iconSize = .constant(0.08)
    layer.iconAllowOverlap = .constant(true)
    layer.iconIgnorePlacement = .constant(true)
    layer.iconRotationAlignment = .constant(.map)
    layer.iconRotate = .expression(Exp(.get) { "bearing" })
    
    do {
        let layerPosition: LayerPosition = {
            if DataHolder.status == 3 {
                return .above(Constants.CLIENT_ICON_LAYER_ID)
            } else {
                return .above(Constants.DEST_ICON_LAYER_ID)
            }
        }()
        try mapView.mapboxMap.addLayer(layer, layerPosition: layerPosition)
    } catch {
        do {
            try mapView.mapboxMap.addLayer(layer)
        } catch {
            print("Error adding car marker layer: \(error)")
        }
    }
}

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
        // Get the set of driver IDs in the new list
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
        // Convert all current car positions to features
        let features: [Feature] = carPositions.map { (driverId, position) in
            var feature = Feature(geometry: .point(Point(position.currentCoordinate)))
            feature.properties = [
                "driverId": .string(driverId),
                "bearing": .number(position.bearing),
                "type": .string(position.type)
            ]
            return feature
        }
        
        // Update the GeoJSON source with the new features
        let featureCollection = FeatureCollection(features: features)
        
        // Check if the source exists, if not create it
        if !mapView.mapboxMap.sourceExists(withId: Constants.CAR_ICON_SOURCE_ID) {
            createSourceAndLayer()
        } else {
            // Update existing source
            try? mapView.mapboxMap.updateGeoJSONSource(
                withId: Constants.CAR_ICON_SOURCE_ID,
                geoJSON: .featureCollection(featureCollection)
            )
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
            
            try? mapView.mapboxMap.addLayer(layer)
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


func removeCarMarkers(mapView: MapView) {
    try? mapView.mapboxMap.removeLayer(withId: Constants.CAR_ICON_LAYER_ID)
    try? mapView.mapboxMap.removeSource(withId: Constants.CAR_ICON_SOURCE_ID)
}



func addDestMarkerAnnotation(mapView: MapView, destination: Point) {
    removeDestMarkerAnnotation(mapView: mapView)
    try? mapView.mapboxMap.addImage(UIImage(named: "destination_icon")!, id: Constants.DEST_ICON_ID)
    var source = GeoJSONSource(id: Constants.DEST_ICON_SOURCE_ID)
    source.data = .feature(Feature(geometry: destination))
    try? mapView.mapboxMap.addSource(source)
    
    var layer = SymbolLayer(id: Constants.DEST_ICON_LAYER_ID, source: Constants.DEST_ICON_SOURCE_ID)
    layer.iconImage = .constant(.name(Constants.DEST_ICON_ID))
    layer.iconSize = .constant(0.02)
    
    do {
        try mapView.mapboxMap.addLayer(layer)
    } catch {
        print("Error adding car marker layer: \(error)")
    }
}


func addClientMarkerAnnotation(_ mapView: MapView, _ clientAddress: Point) {
    removeClientMarkerAnnotation(mapView: mapView)
    do {
        try mapView.mapboxMap.addImage(UIImage(named: "client_flag3")!, id: Constants.CLIENT_ICON_ID)
        
        var source = GeoJSONSource(id: Constants.CLIENT_ICON_SOURCE_ID)
        source.data = .feature(Feature(geometry: clientAddress))
        try mapView.mapboxMap.addSource(source)
        
        var layer = SymbolLayer(id: Constants.CLIENT_ICON_LAYER_ID, source: Constants.CLIENT_ICON_SOURCE_ID)
        layer.iconImage = .constant(.name(Constants.CLIENT_ICON_ID))
        layer.iconSize = .constant(0.06)
        layer.iconAnchor = .constant(.top)
        try mapView.mapboxMap.addLayer(layer)

    } catch {
        
    }
}




func removeCarMarkerAnnotation(mapView: MapView) {
    // Check if the layer exists before trying to remove it
    if (try? mapView.mapboxMap.layer(withId: Constants.CAR_ICON_LAYER_ID)) != nil {
        do {
            try mapView.mapboxMap.removeLayer(withId: Constants.CAR_ICON_LAYER_ID)
        } catch {
            print("Error removing car marker layer: \(error)")
        }
    }
    
    // Check if the source exists before trying to remove it
    if (try? mapView.mapboxMap.source(withId: Constants.CAR_ICON_SOURCE_ID)) != nil {
        do {
            try mapView.mapboxMap.removeSource(withId: Constants.CAR_ICON_SOURCE_ID)
        } catch {
            print("Error removing car marker source: \(error)")
        }
    }
}



func removeRoute(mapView: MapView, _ sourceId: String) {
    do {
        let layers = mapView.mapboxMap.allLayerIdentifiers
        for layer in layers {
            if let source = mapView.mapboxMap.layerProperty(for: layer.id, property: "source").value as? String,
               source == sourceId {
                try mapView.mapboxMap.removeLayer(withId: layer.id)
            }
        }
        if mapView.mapboxMap.sourceExists(withId: sourceId) {
            try mapView.mapboxMap.removeSource(withId: sourceId)
        }
    } catch {
        print("Failed to remove source/layer from map: \(error)")
    }
}

func removeDestMarkerAnnotation(mapView: MapView) {
    // Check if the layer exists before trying to remove it
    if (try? mapView.mapboxMap.layer(withId: Constants.DEST_ICON_LAYER_ID)) != nil {
        do {
            try mapView.mapboxMap.removeLayer(withId: Constants.DEST_ICON_LAYER_ID)
        } catch {
            print("Error removing destination marker layer: \(error)")
        }
    }
    
    // Check if the source exists before trying to remove it
    if (try? mapView.mapboxMap.source(withId: Constants.DEST_ICON_SOURCE_ID)) != nil {
        do {
            try mapView.mapboxMap.removeSource(withId: Constants.DEST_ICON_SOURCE_ID)
        } catch {
            print("Error removing destination marker source: \(error)")
        }
    }
}

func removeClientMarkerAnnotation(mapView: MapView) {
    // Check if the layer exists before trying to remove it
    if (try? mapView.mapboxMap.layer(withId: Constants.CLIENT_ICON_LAYER_ID)) != nil {
        do {
            try mapView.mapboxMap.removeLayer(withId: Constants.CLIENT_ICON_LAYER_ID)
        } catch {
            print("Error removing client marker layer: \(error)")
        }
    }
    
    // Check if the source exists before trying to remove it
    if (try? mapView.mapboxMap.source(withId: Constants.CLIENT_ICON_SOURCE_ID)) != nil {
        do {
            try mapView.mapboxMap.removeSource(withId: Constants.CLIENT_ICON_SOURCE_ID)
        } catch {
            print("Error removing client marker source: \(error)")
        }
    }
}

func removeCircleLayers(mapView: MapView) {
    do{
        
        let pointSourceId = "point-source"
        let pointLayerId = "point-layer"
        
        if mapView.mapboxMap.sourceExists(withId: pointSourceId) {
            try? mapView.mapboxMap.removeSource(withId: pointSourceId)
        }
        if mapView.mapboxMap.layerExists(withId: pointLayerId) {
            try? mapView.mapboxMap.removeLayer(withId: pointLayerId)
        }
    }
    }
