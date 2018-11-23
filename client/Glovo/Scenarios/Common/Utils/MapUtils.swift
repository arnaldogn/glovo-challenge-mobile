//
//  MapUtils.swift
//  Glovo
//
//  Created by Arnaldo on 11/22/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import GoogleMaps

class MapUtils {
    static func drawPolygon(_ map: GMSMapView, areas: [String]?) -> GMSCoordinateBounds? {
        guard let areas = areas else { return nil }
        var bounds = GMSCoordinateBounds()
        for area in areas {
            if let path = GMSPath(fromEncodedPath: area) {
                let polygon = GMSPolygon(path: path)
                polygon.fillColor = UIColor.mainYellow.withAlphaComponent(0.3)
                polygon.map = map
                bounds = bounds.includingPath(path)
            }
        }
        return bounds
    }
    
    static func marker(_ map: GMSMapView, location: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.map = map
        return marker
    }
}

