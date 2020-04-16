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
        return DisplayModel(coord: coord, temperature: main.temp, name: name, timeZone: timezone)
    }
    
    struct Sys: Codable {
        let sunrise: Double
        let sunset: Double
    }
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
}


