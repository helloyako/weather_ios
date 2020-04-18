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
    let coord: Coord
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
    func convertDisplayModel() -> DisplayModel {
        
        return DisplayModel(coord: coord, temperature: main.temp, name: name, timeZone: sys.timezone, weather: weather, maxTemperature: main.temp_max, minTemperature: main.temp_min, sunset: sys.sunset, sunrise: sys.sunrise, humidity: main.humidity, feelsLike: main.feels_like, pressure: main.pressure, visibility: visibility, wind: wind, precipitation: nil, uvIndex: nil, daily: nil, hourly: nil)
    }
    
    struct Sys: Codable {
        let timezone: Double
        let sunrise: Double
        let sunset: Double
    }

}


