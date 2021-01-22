//
//  Drawable.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/19.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
    
    
}
