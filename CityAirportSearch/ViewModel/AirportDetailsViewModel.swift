//
//  AirportDetailsViewModel.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/19.
//

import RxSwift
import RxCocoa

protocol AirportDetailsViewPresentable {
    
    typealias Input = ()
    typealias Output = (
        airportDetails: Driver<AirportViewPresentable>,
        mapDetails: Driver<AirportMapViewPresentable>
    )
    
    typealias Dependecies = (
        model: AirportModel,
        currentLocation: Observable<(lat: Double, lon: Double)?>
    )
    
    var input: AirportDetailsViewPresentable.Input { get }
    var output: AirportDetailsViewPresentable.Output { get }
    
    typealias ViewModelBuilder = (AirportDetailsViewPresentable.Input) ->  AirportDetailsViewPresentable
    
}

class AirportDetailsViewModel: AirportDetailsViewPresentable {
    
    var input: AirportDetailsViewPresentable.Input
    var output: AirportDetailsViewPresentable.Output
    
    init(input: AirportDetailsViewPresentable.Input,
         dependecies: AirportDetailsViewModel.Dependecies) {
        self.input = input
        self.output = AirportDetailsViewModel.output(input: self.input,
                                                     dependecies: dependecies)
        
    }
}

private extension AirportDetailsViewModel {
    
    static func output(input: AirportDetailsViewPresentable.Input,
                       dependecies: AirportDetailsViewPresentable.Dependecies) -> AirportDetailsViewPresentable.Output {
        
        let airportDetails: Driver<AirportViewPresentable> = dependecies.currentLocation
            .filter { $0 != nil }
            .map { $0! }
            .map { [airportModel = dependecies.model] (currentLocation) in
                AirportViewModel(usingModel: airportModel,
                                 currentLocation: currentLocation)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let mapDetails: Driver<AirportMapViewPresentable> = dependecies.currentLocation
            .filter { $0 != nil }
            .map { $0! }
            .map { [airportModel = dependecies.model] (currentLocation) in
                
                guard
                    let lat = Double(airportModel.lat),
                    let lon = Double(airportModel.lon) else {
                    throw CustomError.error(message: "Airport Location missing")
                }
                
                let airportLocation = (lat: lat, lon: lon)
                
                 return AirportMapViewModel(airport: (name: airportModel.name, city: airportModel.city!), currentLocation: currentLocation, airportLocation: airportLocation)

            }
            .asDriver(onErrorDriveWith: .empty())

            return (
                airportDetails: airportDetails,
                mapDetails: mapDetails
            )

    }
}
