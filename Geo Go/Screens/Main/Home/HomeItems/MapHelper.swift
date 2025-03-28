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
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try mapView.mapboxMap.updateGeoJSONSource(withId: sourceId, geoJSON: .feature(lineFeature))
            } catch {
                print("Error updating GeoJSON source: \(error)")
            }
        }
    } else {
        // Create a new source and layer if it doesn't exist
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
        
        
        DispatchQueue.main.async {
            do {
                try mapView.mapboxMap.addSource(lineSource)
                try mapView.mapboxMap.addLayer(lineLayer, layerPosition: .below(layer))
            } catch {
                print("Error adding source or layer: \(error)")
            }
        }
        
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

func updateCarMarkerLocation(_ mapView: MapView, _ point: MyPoint, _ bearing: Float64) {
    let updatedPoint = Point(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
    let updatedFeature = Feature(geometry: updatedPoint)
    
    if let source = try? mapView.mapboxMap.source(withId: Constants.CAR_ICON_SOURCE_ID) as? GeoJSONSource {
        var newSource = source
        newSource.data = .feature(updatedFeature)
        mapView.mapboxMap.updateGeoJSONSource(withId: Constants.CAR_ICON_SOURCE_ID, geoJSON: .feature(updatedFeature))
    } else {
        print("Car marker source not found! Ensure the source is initialized first.")
    }
    
    do {
        try mapView.mapboxMap.updateLayer(
            withId: Constants.CAR_ICON_LAYER_ID,
            type: SymbolLayer.self
        ) { (layer: inout SymbolLayer) in
            layer.iconRotate = .constant(bearing)
        }
    } catch {
        addCarMarkerAnnotation(mapView: mapView, point: point)
        print("Failed to update car marker layer: \(error)")
    }
}


func addCarMarkerAnnotation(mapView: MapView, point: MyPoint) {
    removeCarMarkerAnnotation(mapView: mapView)
    try? mapView.mapboxMap.addImage(UIImage(named: "car_from_above")!, id: Constants.CAR_ICON_ID)
    var source = GeoJSONSource(id: Constants.CAR_ICON_SOURCE_ID)
    let point = Point(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
    source.data = .feature(Feature(geometry: point))
    try? mapView.mapboxMap.addSource(source)
    
    
    var layer = SymbolLayer(id: Constants.CAR_ICON_LAYER_ID, source: Constants.CAR_ICON_SOURCE_ID)
    layer.iconImage = .constant(.name(Constants.CAR_ICON_ID))
    layer.iconSize = .constant(0.08)
    
    do {
        let l = DataHolder.status == 3 ? Constants.CLIENT_ICON_LAYER_ID : Constants.DEST_ICON_LAYER_ID
        try mapView.mapboxMap.addLayer(layer, layerPosition: .above(l))
    } catch {
        do{
            try mapView.mapboxMap.addLayer(layer)
        }catch{}
        print("Error adding car marker layer: \(error)")
    }
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
        print("Error adding client marker annotation: \(error)")
    }
}




func removeClientMarkerAnnotation(mapView: MapView) {
    if let _ = try? mapView.mapboxMap.layer(withId: Constants.CLIENT_ICON_LAYER_ID) {
        try? mapView.mapboxMap.removeLayer(withId: Constants.CLIENT_ICON_LAYER_ID)
    }
    if let _ = try? mapView.mapboxMap.source(withId: Constants.CLIENT_ICON_SOURCE_ID) {
        try? mapView.mapboxMap.removeSource(withId: Constants.CLIENT_ICON_SOURCE_ID)
    }
}

func removeCarMarkerAnnotation(mapView: MapView) {
    if let _ = try? mapView.mapboxMap.layer(withId: Constants.CAR_ICON_LAYER_ID) {
        try? mapView.mapboxMap.removeLayer(withId: Constants.CAR_ICON_LAYER_ID)
    }
    if let _ = try? mapView.mapboxMap.source(withId: Constants.CAR_ICON_SOURCE_ID) {
        try? mapView.mapboxMap.removeSource(withId: Constants.CAR_ICON_SOURCE_ID)
    }
}

func removeDestMarkerAnnotation(mapView: MapView) {
    if let _ = try? mapView.mapboxMap.layer(withId: Constants.DEST_ICON_LAYER_ID) {
        try? mapView.mapboxMap.removeLayer(withId: Constants.DEST_ICON_LAYER_ID)
    }
    if let _ = try? mapView.mapboxMap.source(withId: Constants.DEST_ICON_SOURCE_ID) {
        try? mapView.mapboxMap.removeSource(withId: Constants.DEST_ICON_SOURCE_ID)
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
