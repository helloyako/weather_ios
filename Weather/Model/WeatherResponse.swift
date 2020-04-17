//
//  WeatherResponse.swift
//  Weather
//
//  Created by helloyako on 2020/04/16.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct WeatherResponse: Response, Codable {
    let id: Int
    let name: String
    let timezone: Double
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let wind: Wind
    let visibility: Int
    let coord: Coord
    
    func convertDisplayModel() -> DisplayModel {
        
        return DisplayModel(coord: coord, temperature: main.temp, name: name, timeZone: timezone, weatherName: weather.first?.main, maxTemperature: main.temp_max, minTemperature: main.temp_min, sunset: sys.sunset, sunrise: sys.sunrise, humidity: main.humidity, feelsLike: main.feels_like, pressure: main.pressure, visibility: visibility, wind: wind, precipitation: nil, uvIndex: nil, daily: nil, hourly: nil)
    }
    
    struct Sys: Codable {
        let sunrise: Double
        let sunset: Double
    }

}


