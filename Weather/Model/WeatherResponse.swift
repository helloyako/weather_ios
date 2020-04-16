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
    let dt: Double
    let timezone: Double
    let main: Main
}

struct Main: Codable {
    let temp: Double
}
