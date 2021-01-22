//
//  RouterProtocol.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/19.
//

typealias NavgationBackClosure = (() -> ())

protocol Routing {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigationBack: NavgationBackClosure?)
    
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss: NavgationBackClosure?)
}
