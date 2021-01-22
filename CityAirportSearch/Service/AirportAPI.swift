//
//  AirportAPI.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/12.
//

import RxSwift
import RxCocoa

protocol AirportAPI {
    // 回傳一個 Single, 型別固定為 AirportsResponse
    func fetchAirports() -> Single<AirportsResponse>
}
