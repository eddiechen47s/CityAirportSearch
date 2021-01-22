//
//  AirportService.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/12.
//

import RxSwift
import Alamofire

class AirportService {
    
    static let shared = AirportService()
    private lazy var httpService = AirportHttpService()
}

extension AirportService: AirportAPI {
    // 繼承 AirportAPI, 使用裡面的 fetchAirports()
    func fetchAirports() -> Single<AirportsResponse> {
        
        return Single.create { (single) -> Disposable in
            do {
                try AirportHttpRouter.getAirports // enum AirportHttpRouter
                    .request(usingHttpService: self.httpService)
                    .responseJSON { result in
                        
                        do {
                            let airportJson = try AirportService.parseAirports(result: result)
                            single(.success(airportJson))
                        } catch {
                            single(.error(error))
                        }
                    }
            } catch {
                single(.error(CustomError.error(message: "API 接收資料失敗...")))
            }
            
            return Disposables.create()
        }
    }
    
    
}

extension AirportService {
    
    static func parseAirports(result: AFDataResponse<Any>) throws ->  AirportsResponse {
        guard let data = result.data,
              let airportsResponse = try? JSONDecoder().decode(AirportsResponse.self, from: data)
        else {
            throw CustomError.error(message: "無效的機場 JSON")
        }
        return airportsResponse
    }
    
}
