//
//  LocationService.swift
//  Allume moi
//
//  Created by baboulinet on 12/04/2023.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager();
    public static let shared = LocationService();
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    func askForPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func start(){
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus{
        return locationManager.authorizationStatus
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            locationManager.requestLocation()
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            break
        case .restricted:
            print("DEBUG restricted mode")
            break
        case .denied:
            print("DEBUG denied mode")
            break
        case .notDetermined:
            askForPermission()
            break
        default:
            print("DEBUG in default")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopUpdatingLocation()
            return
        }
        
    }
}
