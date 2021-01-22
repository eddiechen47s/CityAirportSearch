//
//  AirportHttpService.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/12.
//

import Alamofire

class AirportHttpService: HttpService {

    var sessionManager: Session = Session.default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(urlRequest).validate(statusCode: 200..<400)
    }
    
    
}
