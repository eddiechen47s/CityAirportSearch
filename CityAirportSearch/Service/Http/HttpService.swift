//
//  HttpService.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/12.
//

import Alamofire

protocol HttpService {
    var sessionManager: Session { get set }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}
