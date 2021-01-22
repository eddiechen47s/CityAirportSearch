//
//  AirportsCoordinator.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/15.
//

import UIKit
import RxSwift

class AirportsCoordinator: BaseCoordinator {
    
    private let router: Routing
    private let models: Set<AirportModel>
    
    private let bag = DisposeBag()
    
    init(models: Set<AirportModel>,
         router: Routing) {
        self.models = models
        self.router = router
    }
    
    override func start() {
        let view = AirportsViewController.instantiate()
        let locationService = LocationService.shared
        
        view.viewModelBuilder = { [models, locationService, bag] in
            let title = models.first?.city ?? ""
            let viewModel =  AirportsViewModel(
                input: $0,
                dependencies: (
                    title: title,
                    models: models,
                    currentLocation: locationService.currentLocation))
            
            viewModel.router.airportSelect
                .map { [weak self] model in
                    self?.showAirportDetails(model: model)
                }
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        
        self.router.push(view, isAnimated: true, onNavigationBack: isCompleted)
    }
    
}

private extension AirportsCoordinator {
    
    func showAirportDetails(model: AirportModel) {
        let detailsCoordinator = AirportDetailsCoordinator(model: model, router: self.router)
        
        self.add(coordinator: detailsCoordinator)
        
        detailsCoordinator.isCompleted = { [weak self, weak detailsCoordinator] in
            guard let coordinator = detailsCoordinator else { return }
            self?.remove(coordinator: coordinator)
        }
        
        detailsCoordinator.start()
    }
}
