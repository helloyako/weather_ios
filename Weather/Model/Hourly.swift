//
//  Hourly.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}
