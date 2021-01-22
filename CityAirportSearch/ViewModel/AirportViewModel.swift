//
//  AirportViewModel.swift
//  CityAirportSearch
//
//  Created by Keita on 2021/1/17.
//

import Foundation
import CoreLocation

protocol AirportViewPresentable {
    var name: String { get }
    var code: String { get }
    var address: String { get }
    var distance: Double? { get}
    var formattedDistance: String { get }
    var runwayLength: String { get }
    var location: (lat: String, lon: String) { get }
}

struct AirportViewModel: AirportViewPresentable {
    var name: String
    
    var code: String
    
    var address: String
    
    var distance: Double?
    
    var formattedDistance: String {
        return "\(distance?.rounded(.toNearestOrEven) ?? 0 / 1000) Km"
    }
    
    var runwayLength: String
    
    var location: (lat: String, lon: String)
    
    
}

extension AirportViewModel {
    
    init(usingModel model: AirportModel, currentLocation: (lat: Double, lon: Double)) {
        self.name = model.name
        self.code = model.code
        self.address = "\(model.state ?? ""), \(model.country ?? "")"
        self.runwayLength = "Runway Length: \(model.runwayLength ?? "NA")"
        self.location = (lat: model.lat, lon: model.lon)
        self.distance = AirportViewModel.getDistance(
            airportLocation: (lat: Double(model.lat), lon: Double(model.lon)),
            currentLocation: currentLocation)
    }
    
}

private extension AirportViewModel {
    
    static func getDistance(airportLocation: (lat: Double?, lon: Double?),
                     currentLocation: (lat: Double, lon: Double)) -> Double? {
        
        guard
            let airportLat = airportLocation.lat,
            let airportLon = airportLocation.lon else { return nil }
                                
        let current = CLLocation(latitude: currentLocation.lat,
                                 longitude: currentLocation.lon)
        
        let airport = CLLocation(latitude: airportLat,
                                 longitude: airportLon)
        
        return current.distance(from: airport)
    }
    
}

extension AirportViewModel: Comparable {
    
    static func < (lhs: AirportViewModel, rhs: AirportViewModel) -> Bool {
        return lhs.distance ?? 0 < rhs.distance ?? 0
    }
    
    static func == (lhs: AirportViewModel ,rhs: AirportViewModel) -> Bool {
        return lhs.code == rhs.code
    }
    
}
