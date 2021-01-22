//
//  AirportMapViewModel.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/21.
//

protocol AirportMapViewPresentable {
    
    var airport: (name: String, city: String) { get }
    var currentLocation: (lat: Double, lon: Double) { get }
    var airportLocation: (lat: Double, lon: Double) { get }
    
}

struct AirportMapViewModel: AirportMapViewPresentable {
    
    var airport: (name: String, city: String)
    var currentLocation: (lat: Double, lon: Double)
    var airportLocation: (lat: Double, lon: Double)
    
    
}
