//
//  Location.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct Current: Codable {
    let dt: Double
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
    let rain: Precipitaion?
    let snow: Precipitaion?
    
    struct Precipitaion: Codable {
        let oneH: Double?
        let threeH: Double?
        enum CodingKeys: String, CodingKey {
            case oneH = "1h"
            case threeH = "3h"
        }
    }
}
