//
//  MarkerMoveListener.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import SwiftUI

@_spi(Experimental) import MapboxMaps


struct CustomMapView: UIViewRepresentable {
    @Binding var markerOffset: CGFloat
    @Binding var currentCenterCoordinate: CLLocationCoordinate2D

    var vp: CameraOptions
    var mapStyle: StyleURI
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MapView {
        let view = MapView(frame: .zero, mapInitOptions: MapInitOptions(cameraOptions: vp, styleURI: mapStyle))
        setupOrnaments(mapView: view)
        context.coordinator.setupObserver(mapView: view)
        return view
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        // Update your map if needed
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
        
        private var cameraChangedObserver: Cancelable?
        private var cameraIdleObserver: Cancelable?
        
        
        init(_ parent: CustomMapView) {
            self.parent = parent
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
        }
        
    }
}
