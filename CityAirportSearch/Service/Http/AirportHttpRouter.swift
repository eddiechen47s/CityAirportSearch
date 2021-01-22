//
//  AirportHttpRouter.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/12.
//

import Alamofire

enum AirportHttpRouter {
    case getAirports
}

extension AirportHttpRouter: HttpRouter {
    var baseUrlString: String {
        return "https://gist.githubusercontent.com/tdreyno/4278655/raw/7b0762c09b519f40397e4c3e100b097d861f5588"
    }
    
    var path: String {
        switch self {
        case .getAirports:
            return "airports.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAirports:
            return .get
        }
    }
    

    
    
}
