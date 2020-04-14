//
//  WeatherResponse.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let observation: Observation
    let forecasts: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case observation = "current_observation"
        case location
        case forecasts
    }
}
