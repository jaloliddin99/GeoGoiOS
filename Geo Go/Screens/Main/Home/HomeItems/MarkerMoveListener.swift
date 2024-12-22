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
    var isEdgeInsetsChanging: Bool = false
    
    func makeUIView(context: Context) -> MapView {
        let view = MapView(frame: .zero, mapInitOptions: MapInitOptions(cameraOptions: vp, styleURI: mapStyle))
        setupOrnaments(mapView: view)
        
        LogConfiguration.setLoggingLevelForUpTo(.none)
        context.coordinator.subscribeToRouteCoordinates(viewModel, mapView: view)
        
        return view
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        
    }
    
    func dismantleUIView(_ uiView: MapView, coordinator: Coordinator) {
       // coordinator.cancellable?.cancel()
    }
    
    private func setupOrnaments(mapView: MapView) {
        let ornamentOptions = OrnamentOptions(
            scaleBar: ScaleBarViewOptions(visibility: .hidden),
            compass: CompassViewOptions(visibility: .hidden),
            logo: OrnamentConfigurations.hiddenLogoOptions,
            attributionButton: OrnamentConfigurations.hiddenAttributionButtonOptions
        )
        mapView.gestures.options.rotateEnabled = false
        mapView.gestures.options.pitchEnabled = false
        mapView.gestures.options.pinchEnabled = false
        mapView.ornaments.options = ornamentOptions
    }
    class Coordinator: NSObject {
        var parent: CustomMapView
        
        private var cancellables = Set<AnyCancellable>()
        
        private var cameraChangedObserver: Cancelable?
        private var cameraIdleObserver: Cancelable?
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func subscribeToRouteCoordinates(_ viewModel: MainViewModel, mapView: MapView) {
            viewModel.$routeCoordinates
                .compactMap { $0 }
                .sink { [weak self] coor in
                    guard let self = self else { return }
                    let cCoor = condensedLL
                    if (viewModel.status == 1 || viewModel.status == 3 || viewModel.status == 5) && cCoor.size > 1 {
                        drawRoute(mapView, cCoor.toArray())
                        setCameraBounds(mapView, coor)
                    }
                }
                .store(in: &cancellables)
            
            viewModel.$refocusButtonListener
                .sink { isButtonClicked in
                    mapView.camera.ease(to: CameraOptions(center: viewModel.location, zoom: 17), duration: 0.7)
                }
                .store(in: &cancellables)
            
            viewModel.$sDriverRealTimeData
                .sink { [weak self] realTimeData in
                    self?.rtLocationHandler(realTimeData, viewModel, mapView)
                }
                .store(in: &cancellables)
            
            viewModel.$locationHolder
                .sink { [weak self] list in
                    guard let self = self else { return }
                    if viewModel.status == 1 {
                        let loc = list.map { $0.toMyPoint() }
                        setCameraBounds(mapView, loc)
                    }
                }
                .store(in: &cancellables)
            
            cameraChangedObserver = mapView.mapboxMap.onCameraChanged.observe { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if !self.parent.isEdgeInsetsChanging {
                        let vm = self.parent.viewModel
                        if (vm.status == 0 || vm.status == 1) && vm.locationHolder.count <= 1 {
                            self.parent.markerOffset = -50
                        }
                    }
                }
            }
            
            // Mapbox observer for map idle
            cameraIdleObserver = mapView.mapboxMap.onMapIdle.observe { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if !self.parent.isEdgeInsetsChanging {
                        let vm = self.parent.viewModel
                        if (vm.status == 0 || vm.status == 1) && vm.locationHolder.count <= 1 {
                            self.parent.markerOffset = 0
                            let center = mapView.mapboxMap.cameraState.center
                            self.parent.currentCenterCoordinate = center
                        }
                    }
                }
            }
            
            // Combine subscription to status
            viewModel.$status
                .sink { [weak self] status in
                    self?.statusHandler(status, viewModel, mapView)
                }
                .store(in: &cancellables)
        }
        
        private func rtLocationHandler(_ realTimeData: SDriverRealTimeData?, _ viewModel: MainViewModel, _ mapView: MapView){
            guard let rtd = realTimeData else { return }
            let myPoint = MyPoint(latitude: rtd.lat, longitude: rtd.lon)
            
            if viewModel.status == 3 || viewModel.status == 5 {
                guard let order = viewModel.getOrderDetail else { return }
                let onRoute = removeElementsTillClosest(in: condensedLL, to: myPoint)
                if DataHolder.inHome {
                    drawRoute(mapView, condensedLL.toArray())
                    if !onRoute {
                        var coordinates: [String] = []
                        if viewModel.status == 3 {
                            coordinates = getDriverAndClientLoc(order, myPoint)
                        }
                        
                        if viewModel.status == 5 {
                            coordinates = getDriverAndDestination(order, myPoint)
                        }
                        if !coordinates.isEmpty{
                            viewModel.requestToDrawRoute(list: coordinates)
                        }
                    }
                }
            }
            if DataHolder.inHome {
                updateCarMarkerLocation(mapView, myPoint, rtd.bearing)
            }
        }
        
        
        private func statusHandler(_ status: Int, _ viewModel: MainViewModel, _ mapView: MapView){
            let loc = viewModel.locationHolder.isEmpty ? viewModel.location : viewModel.locationHolder[0].addressLocation
            
            
            switch status {
                case 0:
                    self.parent.isEdgeInsetsChanging = true
                    removeRoute(mapView: mapView,"line-source")
                    removeCarMarkerAnnotation(mapView: mapView)
                    removeClientMarkerAnnotation(mapView: mapView)
                    removeDestMarkerAnnotation(mapView: mapView)
                    removeCircleLayers(mapView: mapView)
                    mapView.viewAnnotations.removeAll()
                    
                    var options = CameraOptions(center: loc, zoom: 17)
                    
                    let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    options.padding = edgeInsets
                    mapView.camera.fly(to: options, duration: 0.4){_ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.parent.isEdgeInsetsChanging = false
                        }
                    }
                case 1:
                    let holder = viewModel.locationHolder
                    if holder.isEmpty { return }
                    
                    if holder.count == 1 {
                        self.configureCamera(mapView: mapView, padding: 250)
                    }else {
                        var pointFeatures = holder.map { coordinate -> Feature in
                            return Feature(geometry: .point(Point(coordinate.addressLocation)))
                        }
                        let myPoints = holder.map { point in
                            return MyPoint(latitude: point.addressLocation.latitude, longitude: point.addressLocation.longitude)
                        }
                        mapView.viewAnnotations.removeAll()
                        addViewAnnotation(coordinate: holder.first!.addressLocation, mapView: mapView)
                        setCameraBounds(mapView, myPoints)
                        
                        pointFeatures.removeLast()
                        addCircleLayers(mapView: mapView, userLocations: pointFeatures)
                        let point = myPoints.last!.toPoint()
                        addDestMarkerAnnotation(mapView: mapView, destination: point)
                    }
                    
                    
                case 2:
                    mapView.viewAnnotations.removeAll()
                    removeClientMarkerAnnotation(mapView: mapView)
                    removeDestMarkerAnnotation(mapView: mapView)
                    removeCircleLayers(mapView: mapView)
                    removeRoute(mapView: mapView, "line-source")
                    let loc = viewModel.locationHolder[0].addressLocation
                    let options = CameraOptions(center: loc, zoom: 17)
                    mapView.camera.fly(to: options, duration: 2.0) {_ in
                        mapView.camera.fly(to: CameraOptions(center: loc, zoom: 14), duration: 5.0)
                    }
                    
                case 3:
                    removeRoute(mapView: mapView, "line-source")
                    guard let or = viewModel.getOrderDetail else { return }
                    
                    let p = or.route[0].toPoint()
                    addClientMarkerAnnotation(mapView, p)
                    
                    guard let loc = or.assignee?.location else { return }
                    let point = MyPoint(latitude: loc.lat, longitude: loc.lon)
                    addCarMarkerAnnotation(mapView: mapView, point: point)
                    
                case 4:
                    removeRoute(mapView: mapView, "line-source")
                    let or = viewModel.getOrderDetail
                    if or != nil {
                        let p = or!.route[0].toPoint()
                        addClientMarkerAnnotation(mapView, p)
                    }
                    condensedLL.clear()
                    condensedArrayList.removeAll()
                case 5:
                    removeClientMarkerAnnotation(mapView: mapView)
                    if let route = viewModel.getOrderDetail?.route, route.count > 1 {
                        let p = route.last!.toPoint()
                        addDestMarkerAnnotation(mapView: mapView, destination: p)
                    }
                    guard let loc = viewModel.getOrderDetail?.assignee?.location else { return }
                    let point = MyPoint(latitude: loc.lat, longitude: loc.lon)
                    addCarMarkerAnnotation(mapView: mapView, point: point)
                default:
                    print("Hello World")
            }
        }
       
        func configureCamera(mapView: MapView, padding: CGFloat) {
            self.parent.isEdgeInsetsChanging = true
            let currentCamera = mapView.mapboxMap.cameraState
            
            let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)
            
            var cameraOptions = CameraOptions(center: currentCamera.center, zoom: currentCamera.zoom, bearing: currentCamera.bearing, pitch: currentCamera.pitch)
            cameraOptions.padding = edgeInsets
            
            mapView.camera.fly(to: cameraOptions, duration: 0.4){_ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.parent.isEdgeInsetsChanging = false
                }
            }
        }
        
        deinit {
            cameraChangedObserver?.cancel()
            cameraIdleObserver?.cancel()
        }
        
        
    }
}
