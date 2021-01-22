//
//  Router.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/19.
//

import UIKit

final class Router: NSObject {
    
    private let navigationController: UINavigationController
    private var closures: [String: NavgationBackClosure] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
    
}

extension Router: Routing {
    
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigationBack closure: NavgationBackClosure?) {
        
        guard let viewController = drawable.viewController else { return }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        navigationController.pushViewController(viewController, animated: isAnimated)
    }
    
    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
    
    func popToRoot(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
    
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss closure: NavgationBackClosure?) {
        
        guard let viewController = drawable.viewController else { return }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        navigationController.present(viewController, animated: isAnimated, completion: nil)
        viewController.presentationController?.delegate = self
    }
    
    func executeClosure(_ viewController: UIViewController) -> Void {
        guard let closure = closures.removeValue(forKey: viewController.description) else {
            return
        }
        
        closure()
    }
    
}

extension Router: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        executeClosure(presentationController.presentingViewController)
    }
    
}

extension Router: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        guard !navigationController.viewControllers.contains(previousController) else {
            return
        }
        
        executeClosure(previousController)
        
    }
}
