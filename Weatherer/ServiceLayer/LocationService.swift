//
//  LocationService.swift
//  Weatherer
//
//  Created by HexaHack on 30.04.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation
import MapKit

protocol LocationServiceProtocol {
   func getLocation() -> (Double, Double)
    var locationManager : CLLocationManager { get}
    var location: (latitude: Double, longitude: Double) { get set }
}

class LocationService: NSObject, LocationServiceProtocol,  CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var location: (latitude: Double, longitude: Double)
    
    override init() {
        location = (0.0, 0.0)
    }
   

    func getLocation() -> (Double, Double) {
            locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        
    }
        return location
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        location = (locValue.latitude, locValue.longitude)
        print("\(locValue.latitude) \(locValue.longitude)")
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }

    

    
}
   

