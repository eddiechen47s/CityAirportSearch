//
//  AirportDetailsCoordinator.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/19.
//

import Foundation

class AirportDetailsCoordinator: BaseCoordinator {
    
    private let router: Routing
    private let model: AirportModel
    
    init(model: AirportModel, router: Routing) {
        self.model = model
        self.router = router
    }
    
    override func start() {
        let view = AirportDetailsViewController.instantiate()
        
        let locationService = LocationService.shared
        
        view.viewModelBuilder = { [model, locationService] in
            AirportDetailsViewModel(
                input: $0,
                dependecies: (
                    model: model,
                    currentLocation: locationService.currentLocation
                    )
            )
        }
        
        router.present(view, isAnimated: true, onDismiss: isCompleted)
    }
    
}
