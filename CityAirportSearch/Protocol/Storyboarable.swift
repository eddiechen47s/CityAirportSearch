//
//  Storyboarable.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/11.
//

import UIKit

protocol Storyboarable {
    static func instantiate() -> Self
}

extension Storyboarable where Self: UIViewController {
    
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: className)
    }
    
}
