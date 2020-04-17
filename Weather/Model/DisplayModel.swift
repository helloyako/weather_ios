//
//  DisplayModel.swift
//  Weather
//
//  Created by helloyako on 2020/04/16.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct DisplayModel {
    let coord: Coord
    let temperature: Double
    let name: String
    let timeZone: Double
    var weatherName: String?
    let maxTemperature: Double
    let minTemperature: Double
    var sunset: Double
    var sunrise: Double
    var humidity: Int
    var feelsLike: Double
    var pressure: Int
    var visibility: Int
    var wind: Wind
    
    var precipitation: Double? = nil
    
    
    var uvIndex: Int? = nil
    var daily: [Daily]? = nil
    var hourly: [Hourly]? = nil
}
