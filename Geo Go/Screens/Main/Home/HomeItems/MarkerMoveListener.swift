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
    
    
    @State var isEdgeInsetsChanging: Bool = false
    
    func makeUIView(context: Context) -> MapView {
        let view = MapView(frame: .zero, mapInitOptions: MapInitOptions(cameraOptions: vp, styleURI: mapStyle))
        setupOrnaments(mapView: view)
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
        mapView.gestures.options.rotateEnabled = false
        mapView.gestures.options.pitchEnabled = false
        mapView.gestures.options.pinchEnabled = false
        mapView.ornaments.options = ornamentOptions
    }
    class Coordinator: NSObject {
        var parent: CustomMapView
        var cancellable: AnyCancellable?
        var statusCancellable: AnyCancellable?
        
        private var cameraChangedObserver: Cancelable?
        private var gestureObserver: Cancelable?
        private var cameraIdleObserver: Cancelable?
        private var locationChangeObserver: Cancellable?
        private var driverUpdateLocation: Cancellable?
        private var locationHolderObserver: Cancellable?
        

        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func subscribeToRouteCoordinates(_ viewModel: MainViewModel, mapView: MapView) {
            cancellable = viewModel.$routeCoordinates
                .compactMap { $0 }
                .sink { coor in
                    
                    if ((viewModel.status == 1 || viewModel.status == 3) && coor.count > 1) {
                        drawRoute(mapView, coor)
                        setCameraBounds(mapView, coor)
                    }
                }
            locationChangeObserver = viewModel.$refocusButtonListener
                .sink { isButtonClicked in
                    mapView.camera.ease(to: CameraOptions(center: viewModel.location, zoom: 17), duration: 0.7)
                }
            
            driverUpdateLocation = viewModel.$sDriverRealTimeData
                .sink{ realTimeData in
                    guard let rtd = realTimeData else { return }
                    let myPoint = MyPoint(latitude: rtd.lat, longitude: rtd.lon)
                    
                    updateCarMarkerLocation(mapView, myPoint, rtd.bearing)
                }
            
            locationHolderObserver = viewModel.$locationHolder
                .sink { list in
                    if viewModel.status == 1 {
                        let loc = list.map({ l in l.toMyPoint() })
                        setCameraBounds(mapView, loc)
                    }
                }
            
            cameraChangedObserver = mapView.mapboxMap.onCameraChanged.observe { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if (!self.parent.isEdgeInsetsChanging) {
                        let vm = self.parent.viewModel
                        if (vm.status == 0 || vm.status == 1) && vm.locationHolder.count <= 1 {
                            self.parent.markerOffset = -50
                        }
                    }
                }
            }
            
            cameraIdleObserver = mapView.mapboxMap.onMapIdle.observe { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if (!self.parent.isEdgeInsetsChanging) {
                        let vm = self.parent.viewModel
                        if (vm.status == 0 || vm.status == 1) && vm.locationHolder.count <= 1 {
                            self.parent.markerOffset = 0
                            let center = mapView.mapboxMap.cameraState.center
                            self.parent.currentCenterCoordinate = center
                        }
                    }
                }
            }
            
            
            statusCancellable = viewModel.$status
                .sink { status in
                    let loc = viewModel.locationHolder.isEmpty ? viewModel.location : viewModel.locationHolder[0].addressLocation
                    
                    let cSelectedPoint = Point(CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude))

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
                            
                            if holder.count == 1 {
                                configureCamera(mapView: mapView, padding: 250, self.parent.$isEdgeInsetsChanging)
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
                            removeCircleLayers(mapView: mapView)
                            removeRoute(mapView: mapView, "line-source")
                            let loc = viewModel.locationHolder[0].addressLocation
                            let options = CameraOptions(center: loc, zoom: 17)
                            mapView.camera.fly(to: options, duration: 2.0) {_ in
                                mapView.camera.fly(to: CameraOptions(center: loc, zoom: 14), duration: 5.0)
                            }

                        case 3:
                            removeRoute(mapView: mapView, "line-source")
                            removeCarMarkerAnnotation(mapView: mapView)
                            
                            addClientMarkerAnnotation(mapView: mapView, clientAddress: cSelectedPoint)
                            guard let loc = viewModel.getOrderDetail?.assignee?.location else { return }
                            let point = MyPoint(latitude: loc.lat, longitude: loc.lon)
                            addCarMarkerAnnotation(mapView: mapView, point: point)
                            
                        case 4:
                            removeRoute(mapView: mapView, "line-source")
                            guard let loc = viewModel.getOrderDetail?.assignee?.location else { return }
                            let point = MyPoint(latitude: loc.lat, longitude: loc.lon)
                            addCarMarkerAnnotation(mapView: mapView, point: point)
                            addClientMarkerAnnotation(mapView: mapView, clientAddress: cSelectedPoint)

                        case 5:
                            removeClientMarkerAnnotation(mapView: mapView)
                            
                            if let route = viewModel.getOrderDetail?.route, route.count >= 1 {
                                let lat = route[route.count-1].point.coordinates.lat
                                let lon = route[route.count-1].point.coordinates.lon
                                let point = Point(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                                addDestMarkerAnnotation(mapView: mapView, destination: point)
                            }
                            
                            guard let location = viewModel.getOrderDetail?.assignee?.location
                                    else { return }
                            let coor = MyPoint(latitude: location.lat, longitude: location.lon)

                            addCarMarkerAnnotation(mapView: mapView, point: coor)
                            
                        default:
                            print("Hello World")
                    }
                }
        }
        
        
        deinit {
            cameraChangedObserver?.cancel()
            cameraIdleObserver?.cancel()
            cancellable?.cancel()
            gestureObserver?.cancel()
            locationHolderObserver?.cancel()
        }
        
    }
}
