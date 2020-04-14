//
//  Observation.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct Observation: Codable {
    let wind: Wind
    let atmosphere: Atmosphere
    let astronomy: Astronomy
    let condition: Condition
    let pubDate: Int
}

struct Wind: Codable {
    let chill: Int
    let direction: Int
    let speed: Double
}
struct Atmosphere: Codable {
    let humidity: Int
    let visibility: Int
    let pressure: Double
}
struct Astronomy: Codable {
    let sunrise: String
    let sunset: String
}
struct Condition: Codable {
    let text: String
    let code: Int
    let temperature: Int
}
