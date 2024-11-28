//
//  MarkerMoveListener.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import SwiftUI
import Combine
@_spi(Experimental) import MapboxMaps
import Turf
import CoreLocation


struct CustomMapView: UIViewRepresentable {
    @Binding var markerOffset: CGFloat
    @Binding var currentCenterCoordinate: CLLocationCoordinate2D
    @ObservedObject var viewModel: MainViewModel
    
    var vp: CameraOptions
    var mapStyle: StyleURI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MapView {
        let view = MapView(frame: .zero, mapInitOptions: MapInitOptions(cameraOptions: vp, styleURI: mapStyle))
        setupOrnaments(mapView: view)
        context.coordinator.setupObserver(mapView: view)
        
        context.coordinator.subscribeToRouteCoordinates(viewModel, mapView: view)
        
        return view
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        
    }
    
    func dismantleUIView(_ uiView: MapView, coordinator: Coordinator) {
        coordinator.cancellable?.cancel()
    }
    
    private func setupOrnaments(mapView: MapView) {
        let ornamentOptions = OrnamentOptions(
            scaleBar: ScaleBarViewOptions(visibility: .hidden),
            compass: CompassViewOptions(visibility: .hidden),
            logo: OrnamentConfigurations.hiddenLogoOptions,
            attributionButton: OrnamentConfigurations.hiddenAttributionButtonOptions
        )
        
        mapView.ornaments.options = ornamentOptions
    }
    class Coordinator: NSObject {
        var parent: CustomMapView
        var cancellable: AnyCancellable?
        var statusCancellable: AnyCancellable?
        
        private var cameraChangedObserver: Cancelable?
        private var cameraIdleObserver: Cancelable?
        private var locationChangeObserver: Cancellable?
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func subscribeToRouteCoordinates(_ viewModel: MainViewModel, mapView: MapView) {
            cancellable = viewModel.$routeCoordinates
                .compactMap { $0 }
                .sink { [weak self] coor in
                    if viewModel.status == 1 || viewModel.status == 3 {
                        self?.drawRoute(mapView: mapView, coordinates: coor)
                        if mapView.camera.cameraAnimators.isEmpty {
                            self?.setCameraBounds(mapView: mapView, coordinates: coor)
                        }
                    }
                }
            locationChangeObserver = viewModel.$refocusButtonListener
                .sink { isButtonClicked in
                    mapView.camera.ease(to: CameraOptions(center: viewModel.location, zoom: 13), duration: 1.0)
                }
            
            
            statusCancellable = viewModel.$status
                .sink { status in
                    let loc = viewModel.locationHolder.isEmpty ? viewModel.location : viewModel.locationHolder[0].addressLocation
                    
                    let cSelectedPoint = Point(CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude))

                    switch status {
                        case 0:
                            self.removeRoute(mapView: mapView)
                            self.removeCarMarkerAnnotation(mapView: mapView)
                            self.removeClientMarkerAnnotation(mapView: mapView)
                            self.removeDestMarkerAnnotation(mapView: mapView)
                            self.removeCircleLayers(mapView: mapView)
                            mapView.viewAnnotations.removeAll()
                            
                            let options = CameraOptions(center: loc, zoom: 13)
                            mapView.camera.fly(to: options, duration: 2.0)
                        case 1:
                            let holder = viewModel.locationHolder
                            
                            if holder.count == 1 {
                                self.addClientMarkerAnnotation(mapView: mapView, clientAddress: cSelectedPoint)
                            }else {
                                let pointFeatures = holder.map { coordinate -> Feature in
                                    return Feature(geometry: .point(Point(coordinate.addressLocation)))
                                }
                                let myPoints = holder.map { point in
                                    return MyPoint(latitude: point.addressLocation.latitude, longitude: point.addressLocation.longitude)
                                }
                                self.setCameraBounds(mapView: mapView, coordinates: myPoints)
                                
                                self.addCircleLayers(mapView: mapView, userLocations: pointFeatures)
                                
                                mapView.viewAnnotations.removeAll()
                                
                                holder.enumerated().forEach { index, ua in
                                    if index == 0 || index == (holder.count - 1) {
                                        self.addViewAnnotation(coordinate: ua.addressLocation, mapView: mapView, address: ua.addressName)
                                    }
                                }
                            }
                            
                            
                        case 2:
                            self.removeClientMarkerAnnotation(mapView: mapView)
                            self.removeCircleLayers(mapView: mapView)
                            self.removeRoute(mapView: mapView)
                            mapView.viewAnnotations.removeAll()
                            let loc = viewModel.locationHolder[0].addressLocation
                            let options = CameraOptions(center: loc, zoom: 15)
                            mapView.camera.fly(to: options, duration: 2.0) {_ in
                                mapView.camera.fly(to: CameraOptions(center: loc, zoom: 11), duration: 8.0)
                            }

                        case 3:
                            self.removeRoute(mapView: mapView)
                            self.removeCarMarkerAnnotation(mapView: mapView)
                            
                            self.addClientMarkerAnnotation(mapView: mapView, clientAddress: cSelectedPoint)
                            guard let loc = viewModel.getOrderDetail?.assignee?.location else { return }
                            let point = MyPoint(latitude: loc.lat, longitude: loc.lon)
                            self.addCarMarkerAnnotation(mapView: mapView, point: point)
                            
                        case 4:
                            self.removeRoute(mapView: mapView)
                            guard let loc = viewModel.getOrderDetail?.assignee?.location else { return }
                            let point = MyPoint(latitude: loc.lat, longitude: loc.lon)
                            self.addCarMarkerAnnotation(mapView: mapView, point: point)
                            self.addClientMarkerAnnotation(mapView: mapView, clientAddress: cSelectedPoint)

                        case 5:
                            self.removeClientMarkerAnnotation(mapView: mapView)
                            
                            if let route = viewModel.getOrderDetail?.route, route.count >= 1 {
                                let lat = route[route.count-1].point.coordinates.lat
                                let lon = route[route.count-1].point.coordinates.lon
                                let point = Point(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                                self.addDestMarkerAnnotation(mapView: mapView, destination: point)
                            }
                            
                            guard let location = viewModel.getOrderDetail?.assignee?.location
                                    else { return }
                            let coor = MyPoint(latitude: location.lat, longitude: location.lon)
                            self.addCarMarkerAnnotation(mapView: mapView, point: coor)
                            
                        default:
                            print("Hello World")
                    }
                }
        }
        
        func setupObserver(mapView: MapView) {
            
            cameraChangedObserver = mapView.mapboxMap.onCameraChanged.observe { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.parent.markerOffset = -50
                }
            }
            
            cameraIdleObserver = mapView.mapboxMap.onMapIdle.observe { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.parent.markerOffset = 0
                    let center = mapView.mapboxMap.cameraState.center
                    self.parent.currentCenterCoordinate = center
                }
            }
        }
        
        deinit {
            cameraChangedObserver?.cancel()
            cameraIdleObserver?.cancel()
            cancellable?.cancel()
        }
        
        func drawRoute(mapView: MapView, coordinates: [MyPoint]) {
            let sourceId = "line-source"
            let layerId = "line-layer"
            
            // Remove existing route on the main thread to keep UI responsive
            removeRoute(mapView: mapView)
            
            // Perform heavy computation (coordinate mapping and feature creation) on a background thread
            DispatchQueue.global(qos: .userInitiated).async {
                let lineCoordinates = coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
                let lineFeature = Feature(geometry: .lineString(LineString(lineCoordinates)))
                
                var lineSource = GeoJSONSource(id: sourceId)
                lineSource.data = .feature(lineFeature)
                lineSource.lineMetrics = true
                
                var lineLayer = LineLayer(id: layerId, source: sourceId)
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
                
                let lowZoomWidth = 10
                let highZoomWidth = 20
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
                
                DispatchQueue.main.async {
                    do {
                        try mapView.mapboxMap.addSource(lineSource)
                        try mapView.mapboxMap.addLayer(lineLayer, layerPosition: nil)
                    } catch {
                        print("Error adding source or layer: \(error)")
                    }
                }
            }
        }

        func setCameraBounds(
            mapView: MapView,
            coordinates: [MyPoint]
        ){
            if !coordinates.isEmpty {
                let coor = coordinates.map { point in
                    CLLocationCoordinate2DMake(point.latitude, point.longitude)
                }
                let referenceCamera = CameraOptions(zoom: 5, bearing: 45)
                guard let camera = try? mapView.mapboxMap.camera(
                    for: coor,
                    camera: referenceCamera,
                    coordinatesPadding: UIEdgeInsets(top: 50, left: 50, bottom: 300, right: 50),
                    maxZoom: nil,
                    offset: nil) else { return }
                mapView.camera.fly(to: camera, duration: 2.0)
            }
        }
        func addViewAnnotation(coordinate: CLLocationCoordinate2D, mapView: MapView, address: String) {
            let annotationView = AnnotationView(text: address)
            annotationView.frame.size = CGSize(width: 150, height: 50)
            
            
            let annotation = ViewAnnotation(
                coordinate: coordinate,
                view: annotationView
            )
            annotation.variableAnchors = .all
            
            annotation.allowOverlap = true
            annotation.view.anchorPoint = CGPoint(x: 50.0, y: 1000.0)
            mapView.viewAnnotations.add(annotation)
        }
        private func addCircleLayers(mapView: MapView, userLocations: [Feature]){
            removeCircleLayers(mapView: mapView)
            let pointSourceId = "point-source"
            let pointLayerId = "point-layer"
            
            var pointSource = GeoJSONSource(id: pointSourceId)
            pointSource.data = .featureCollection(FeatureCollection(features: userLocations))
            
            var pointLayer = CircleLayer(id: pointLayerId, source: pointSourceId)
            pointLayer.circleColor = .constant(StyleColor(.white))
            pointLayer.circleRadius = .constant(7)
            pointLayer.circleStrokeWidth = .constant(5.0)
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
        
        private func addCarMarkerAnnotation(mapView: MapView, point: MyPoint) {
          
            removeCarMarkerAnnotation(mapView: mapView)
            
            try? mapView.mapboxMap.addImage(UIImage(named: "car_from_above")!, id: Constants.CAR_ICON_ID)
            
            var source = GeoJSONSource(id: Constants.CAR_ICON_SOURCE_ID)
            let point = Point(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
            source.data = .feature(Feature(geometry: point))
            try? mapView.mapboxMap.addSource(source)
            
            
            var layer = SymbolLayer(id: Constants.CAR_ICON_LAYER_ID, source: Constants.CAR_ICON_SOURCE_ID)
            layer.iconImage = .constant(.name(Constants.CAR_ICON_ID))
            layer.iconAnchor = .constant(.bottom)
            layer.iconOffset = .constant([0, 12])
            layer.iconSize = .constant(0.12)
            layer.iconOffset = .constant([0, -50])
                        
            try? mapView.mapboxMap.addLayer(layer)
        }
        
        
        private func addDestMarkerAnnotation(mapView: MapView, destination: Point) {
            removeDestMarkerAnnotation(mapView: mapView)
            try? mapView.mapboxMap.addImage(UIImage(named: "destination")!, id: Constants.DEST_ICON_ID)
            var source = GeoJSONSource(id: Constants.DEST_ICON_SOURCE_ID)
            source.data = .feature(Feature(geometry: destination))
            try? mapView.mapboxMap.addSource(source)
            
            var layer = SymbolLayer(id: Constants.DEST_ICON_LAYER_ID, source: Constants.DEST_ICON_SOURCE_ID)
            layer.iconImage = .constant(.name(Constants.DEST_ICON_ID))
            layer.iconSize = .constant(0.035)
                       
            try? mapView.mapboxMap.addLayer(layer)
        }
        
        
        private func addClientMarkerAnnotation(mapView: MapView, clientAddress: Point) {
            removeClientMarkerAnnotation(mapView: mapView)
            try? mapView.mapboxMap.addImage(UIImage(named: "client_flag")!, id: Constants.CLIENT_ICON_ID)
            var source = GeoJSONSource(id: Constants.CLIENT_ICON_SOURCE_ID)
            source.data = .feature(Feature(geometry: clientAddress))
            try? mapView.mapboxMap.addSource(source)
            
            var layer = SymbolLayer(id: Constants.CLIENT_ICON_LAYER_ID, source: Constants.CLIENT_ICON_SOURCE_ID)
            layer.iconImage = .constant(.name(Constants.CLIENT_ICON_ID))
            layer.iconSize = .constant(0.08)
            
            try? mapView.mapboxMap.addLayer(layer)
        }
        
        
        
        private func removeClientMarkerAnnotation(mapView: MapView) {
            if let _ = try? mapView.mapboxMap.layer(withId: Constants.CLIENT_ICON_LAYER_ID) {
                try? mapView.mapboxMap.removeLayer(withId: Constants.CLIENT_ICON_LAYER_ID)
            }
            if let _ = try? mapView.mapboxMap.source(withId: Constants.CLIENT_ICON_SOURCE_ID) {
                try? mapView.mapboxMap.removeSource(withId: Constants.CLIENT_ICON_SOURCE_ID)
            }
        }
        
        private func removeCarMarkerAnnotation(mapView: MapView) {
            if let _ = try? mapView.mapboxMap.layer(withId: Constants.CAR_ICON_LAYER_ID) {
                try? mapView.mapboxMap.removeLayer(withId: Constants.CAR_ICON_LAYER_ID)
            }
            if let _ = try? mapView.mapboxMap.source(withId: Constants.CAR_ICON_SOURCE_ID) {
                try? mapView.mapboxMap.removeSource(withId: Constants.CAR_ICON_SOURCE_ID)
            }
        }
        
        private func removeDestMarkerAnnotation(mapView: MapView) {
            if let _ = try? mapView.mapboxMap.layer(withId: Constants.DEST_ICON_LAYER_ID) {
                try? mapView.mapboxMap.removeLayer(withId: Constants.DEST_ICON_LAYER_ID)
            }
            if let _ = try? mapView.mapboxMap.source(withId: Constants.DEST_ICON_SOURCE_ID) {
                try? mapView.mapboxMap.removeSource(withId: Constants.DEST_ICON_SOURCE_ID)
            }
        }
        
        
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
            } catch {
                print("Failed to remove source/layer from map: \(error)")
            }
        }
        
        
    }
}
