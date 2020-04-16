//
//  WeatherResponse.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct OneCallResponse: Response, Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}
