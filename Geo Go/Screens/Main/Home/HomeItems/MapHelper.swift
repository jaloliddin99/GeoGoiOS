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
    lineLayer.lineGradient = .expression(
        Exp(.interpolate) {
            Exp(.linear)
            Exp(.lineProgress)
            0.5
            UIColor.main
            0.6
            UIColor.green
            0.7
            UIColor.yellow
            1
            UIColor.main
        }
    )
    
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

func updateCarMarkers(mapView: MapView, driverList: [SDriverData]) {
    removeCarMarkers(mapView: mapView)
    
    if let image = UIImage(named: "car_from_above") {
        try? mapView.mapboxMap.addImage(image, id: Constants.CAR_ICON_ID)
    }
    
    // Build GeoJSON features for all drivers
    let features: [Feature] = driverList.map { driver in
        var feature = Feature(geometry: .point(Point(CLLocationCoordinate2D(latitude: driver.lat, longitude: driver.long))))
        feature.properties = [
            "driverId": .string(driver.driverId),
            "bearing": .number(driver.bearing),
            "type": .string(driver.type)
        ]
        return feature
    }
    
    var source = GeoJSONSource(id: Constants.CAR_ICON_SOURCE_ID)
    source.data = .featureCollection(FeatureCollection(features: features))
    
    try? mapView.mapboxMap.addSource(source)
    
    var layer = SymbolLayer(id: Constants.CAR_ICON_LAYER_ID, source: Constants.CAR_ICON_SOURCE_ID)
    layer.iconImage = .constant(.name(Constants.CAR_ICON_ID))
    layer.iconSize = .constant(0.08)
    layer.iconAllowOverlap = .constant(true)
    layer.iconIgnorePlacement = .constant(true)
    layer.iconRotationAlignment = .constant(.map)
    layer.iconRotate = .expression(Exp(.get) { "bearing" })
    
    try? mapView.mapboxMap.addLayer(layer)
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
