//
//  AirportPin.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/21.
//

import MapKit

class AirportPin: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(name: String, city: String = "", coordinate: CLLocationCoordinate2D) {
        self.title = name
        self.subtitle = city
        self.coordinate = coordinate
    }
    
}
