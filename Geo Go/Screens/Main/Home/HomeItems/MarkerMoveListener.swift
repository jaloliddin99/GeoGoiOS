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
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func subscribeToRouteCoordinates(_ viewModel: MainViewModel, mapView: MapView) {
            cancellable = viewModel.$routeCoordinates
                .compactMap { $0 }
                .sink { [weak self] routeCoordinates in
                    self?.drawRoute(mapView: mapView, coordinates: routeCoordinates, userLocations: viewModel.locationHolder)
                }
            
            statusCancellable = viewModel.$status
                .sink { [weak self] status in
                    if status == 0 {
                        self?.removeRoute(mapView: mapView)
                        mapView.viewAnnotations.removeAll()
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
        
        func drawRoute(mapView: MapView, coordinates: [MyPoint], userLocations: [UserSelectedAddress]) {
            let sourceId = "line-source"
            let layerId = "line-layer"
            
            removeRoute(mapView: mapView)
            
            let lineCoordinates = coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            let lineFeature = Feature(geometry: .lineString(LineString(lineCoordinates)))
            var lineSource = GeoJSONSource(id: sourceId)
            lineSource.data = .feature(lineFeature)
            
            var lineLayer = LineLayer(id: layerId, source: sourceId)
            lineLayer.lineColor = .constant(StyleColor(.main))
            lineLayer.lineWidth = .constant(6.0)
            lineLayer.lineCap = .constant(.round)
            lineLayer.lineJoin = .constant(.round)
            
            try! mapView.mapboxMap.addSource(lineSource)
            try! mapView.mapboxMap.addLayer(lineLayer, layerPosition: nil)
            
            
            setCameraBounds(mapView: mapView,
                            coordinates: coordinates,
                            userLocations: userLocations)
            
        }
        
        private func setCameraBounds(
            mapView: MapView,
            coordinates: [MyPoint],
            userLocations: [UserSelectedAddress]
        ){
            
            if !coordinates.isEmpty && !userLocations.isEmpty {
                let coor = coordinates.map { point in
                    CLLocationCoordinate2DMake(point.latitude, point.longitude)
                }
                
                mapView.viewAnnotations.removeAll()
                
                userLocations.enumerated().forEach { index, ua in
                    let coor = CLLocationCoordinate2DMake(
                        ua.addressLocation.latitude,
                        ua.addressLocation.longitude
                    )
                    if index == 0 || index == (userLocations.count - 1) {
                        addViewAnnotation(coordinate: coor, mapView: mapView, address: ua.addressName)
                    }
                }

                
                addCircleLayers(mapView: mapView, userLocations: userLocations)

                let referenceCamera = CameraOptions(zoom: 5, bearing: 45)
                guard let camera = try? mapView.mapboxMap.camera(
                    for: coor,
                    camera: referenceCamera,
                    coordinatesPadding: UIEdgeInsets(top: 50, left: 50, bottom: 300, right: 50),
                    maxZoom: nil,
                    offset: nil) else { return }
                mapView.mapboxMap.setCamera(to: camera)
            }
        }
        private func addViewAnnotation(coordinate: CLLocationCoordinate2D, mapView: MapView, address: String) {
            let annotationView = AnnotationView(text: address)
            annotationView.frame.size = CGSize(width: 150, height: 50)
            
//            let anchor = coordinate.longitude - mapView.mapboxMap.cameraState.center.longitude > 0 ?
//            ViewAnnotationAnchor.bottomRight : ViewAnnotationAnchor.bottomLeft
            
            let annotation = ViewAnnotation(
                coordinate: coordinate,
                view: annotationView
            )
            annotation.variableAnchors = .all
            
            annotation.allowOverlap = true
            annotation.view.anchorPoint = CGPoint(x: 50.0, y: 1000.0)
            mapView.viewAnnotations.add(annotation)
        }
        private func addCircleLayers(mapView: MapView, userLocations: [UserSelectedAddress]){
            let pointSourceId = "point-source"
            let pointLayerId = "point-layer"
            let pointFeatures = userLocations.map { coordinate -> Feature in
                let lat = coordinate.addressLocation.latitude
                let lon = coordinate.addressLocation.longitude
                return Feature(geometry: .point(Point(CLLocationCoordinate2D(latitude: lat, longitude: lon))))
            }

            var pointSource = GeoJSONSource(id: pointSourceId)
            pointSource.data = .featureCollection(FeatureCollection(features: pointFeatures))
            
            var pointLayer = CircleLayer(id: pointLayerId, source: pointSourceId)
            pointLayer.circleColor = .constant(StyleColor(.red))
            pointLayer.circleRadius = .constant(8.0)
            pointLayer.circleStrokeWidth = .constant(2.0)
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
}
