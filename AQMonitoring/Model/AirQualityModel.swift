//
//  AirQualityModel.swift
//  AQMonitoring
//
//  Created by Kajal Nasit  on 08/01/22.
//

import Foundation

struct AirQualityModel: Codable {
    let city : String?
    let aqi : Double?

    enum CodingKeys: String, CodingKey {

        case city = "city"
        case aqi = "aqi"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        aqi = try values.decodeIfPresent(Double.self, forKey: .aqi)
    }

}
