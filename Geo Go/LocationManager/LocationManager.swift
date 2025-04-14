//
//  LocationManager.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//


import Foundation
import CoreLocation

func bearing(from startLocation: CLLocationCoordinate2D, to endLocation: CLLocationCoordinate2D) -> Double {
    let lat1 = startLocation.latitude.radians
    let lon1 = startLocation.longitude.radians
    
    let lat2 = endLocation.latitude.radians
    let lon2 = endLocation.longitude.radians
    
    let deltaLon = lon2 - lon1
    let y = sin(deltaLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
    let bearingRadians = atan2(y, x)

    var bearingDegrees = bearingRadians.degrees
    if bearingDegrees < 0 {
        bearingDegrees += 360
    }
    
    return bearingDegrees
}

extension Double {
    var radians: Double { self * .pi / 180 }
    var degrees: Double { self * 180 / .pi }
}


final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    private var locationManager = CLLocationManager()
    private var isPermissionRequested = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if !isPermissionRequested {
            isPermissionRequested = true
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if isPermissionRequested && (status == .authorizedWhenInUse || status == .authorizedAlways) {
            isPermissionRequested = false
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if newLocation != location {
            UserDefaults.standard.set(newLocation.coordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(newLocation.coordinate.longitude, forKey: "lon")
            location = newLocation
            DataHolder.location = newLocation.coordinate
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

