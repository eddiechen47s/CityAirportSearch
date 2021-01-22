//
//  BaseCoordinator.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/11.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = []
    var isCompleted: (() -> ())?
    
    func start() {
        fatalError("children should implement 'start'..")
    }
    
}
