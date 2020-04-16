//
//  Main.swift
//  Weather
//
//  Created by helloyako on 2020/04/16.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let feels_like: Double?
}
