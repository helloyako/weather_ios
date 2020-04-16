//
//  ListResponse.swift
//  Weather
//
//  Created by helloyako on 2020/04/16.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct ListResponse: Response, Codable {
    let list: [ListItem]
    
}

struct ListItem: Codable {
    let id: Int
    let dt: Double
    let name: String
    let sys: Sys
    let main: Main
    
    func convertWeatherResponseModel() -> WeatherResponse {
        return WeatherResponse(id: id, name: name, dt: dt, timezone: sys.timezone, main: main)
    }
}

struct Sys: Codable {
    let timezone: Double
}
