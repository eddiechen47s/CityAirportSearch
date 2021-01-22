//
//  AppCoordinator.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/11.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    
    private let navgationController: UINavigationController = {
        let navigationController = UINavigationController()

        let navBar = navigationController.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.barTintColor = .white
        navBar.tintColor = .white
//        navBar.backgroundColor = #colorLiteral(red: 0.1462399662, green: 0.1462444067, blue: 0.1462419927, alpha: 1)
        navBar.backgroundColor = .systemRed
        
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let router = Router(navigationController: self.navgationController)
        
        let searchCityCoordinator = SearchCityCoordinator(router: router)
        self.add(coordinator: searchCityCoordinator)
        
        searchCityCoordinator.isCompleted = { [weak self, weak searchCityCoordinator] in
            guard let coordinator = searchCityCoordinator else { return }
            self?.remove(coordinator: coordinator)
        }
        
        searchCityCoordinator.start()
        
        window.rootViewController = navgationController
        window.makeKeyAndVisible()
    }
}
