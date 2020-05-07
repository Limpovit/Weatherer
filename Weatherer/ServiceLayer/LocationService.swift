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
   func getLocation() -> (latitude: Double?, longitude: Double?)
    
}

class LocationService: NSObject, LocationServiceProtocol,  CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
   
    override init() {
    }
   

    func getLocation() -> (latitude: Double?, longitude: Double?) {
        var location: (latitude: Double?, longitude: Double?)
            locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
           location = (latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude)
    }
        return location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}        
        print("\(locValue.latitude) \(locValue.longitude)")
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    

    
}
   

