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
    var sunset: Double? = nil
    var sunrise: Double? = nil
    var precipitation: String? = nil
    var humidity: Int? = nil
    var wind: String? = nil
    var feelsLike: Int? = nil
    var pressure: Int? = nil
    var visibility: Int? = nil
    var uvIndex: Int? = nil
    var daily: [Daily]? = nil
    var hourly: [Hourly]? = nil
}
