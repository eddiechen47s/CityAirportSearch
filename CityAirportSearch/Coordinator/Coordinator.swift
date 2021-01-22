//
//  Coordinator.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/11.
//

protocol Coordinator: class {
    
    var childCoordinator: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    func add(coordinator: Coordinator) -> Void {
        childCoordinator.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) -> Void {
        childCoordinator = childCoordinator.filter({ $0 !== coordinator } )
    }
}
