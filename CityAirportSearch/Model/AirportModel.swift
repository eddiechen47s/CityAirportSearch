//
//  AirportModel.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/12.
//


struct AirportModel: Codable {
    // 這隻 api 有些沒值, + ? 不然會找不到
    let code, lat, lon, name: String
    let city, state, country, woeid: String?
    let tz, phone, type, email: String?
    let url, runwayLength, elev, icao: String?
    let directFlights, carriers: String?
    
    enum CodingKeys: String, CodingKey {
        case code, lat, lon, name, city, state, country, woeid, tz, phone, type, email, url
        case runwayLength = "runway_length"
        case elev, icao
        case directFlights = "direct_flights"
        case carriers
    }
}

extension AirportModel: Equatable {
    // 比較是否相同
    static func == (lhs: AirportModel, rhs: AirportModel) -> Bool {
        return lhs.code == rhs.code
    }
}

extension AirportModel: Hashable {
    func hash(into hasher: inout Hasher) {
        // 檢查 code 是否一樣
        hasher.combine(code)
//        hasher.combine(email)
    }
}

// 設定 型別 外號
typealias AirportsResponse = [AirportModel]
