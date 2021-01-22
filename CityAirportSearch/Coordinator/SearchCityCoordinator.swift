//
//  SearchCityCoordinator.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/11.
//

import UIKit
import RxSwift

class SearchCityCoordinator: BaseCoordinator {
    
    var router: Routing
    
    private let bag = DisposeBag()
    
    init(router: Routing) {
        self.router = router
    }
    
    override func start() {
        
        let view = SearchCityViewController.instantiate()
        let service = AirportService.shared
        
        view.viewModelBuilder = { [bag] in
            let viewModel = SearchCityViewModel(input: $0, airportService: service)
            
            viewModel.router.citySelected
                .map({ [weak self] in
//                    print("models 收到 \(models)")
                    
                    guard let `self` = self else { return }
                    self.showAirports(usingModel: $0)
                })
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        
        router.push(view, isAnimated: true, onNavigationBack: isCompleted)
    }
}

extension SearchCityCoordinator {
    
    func showAirports(usingModel models: Set<AirportModel>) -> Void {
        let airportsCoordinator = AirportsCoordinator(models: models,
                                                      router: self.router)
        
        self.add(coordinator: airportsCoordinator)
        
        airportsCoordinator.isCompleted = { [weak self, weak airportsCoordinator] in
            guard let coordinator = airportsCoordinator else { return }
            self?.remove(coordinator: coordinator)
        }
        
        airportsCoordinator.start()
    }
    
}
