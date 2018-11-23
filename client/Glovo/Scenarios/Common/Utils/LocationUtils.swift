//
//  Helper.swift
//  Glovo
//
//  Created by Arnaldo on 11/22/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import MapKit

class LocationUtils {
    static func getCityCoordinates(name: String, completion:@escaping (CLLocationCoordinate2D?)->()) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(name) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
            completion(location.coordinate)
        }
    }
}
