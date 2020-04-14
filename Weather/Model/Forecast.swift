//
//  Forecast.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let day: String
    let date: TimeInterval
    let low: Int
    let high: Int
    let text: String
    let code: Int
}
