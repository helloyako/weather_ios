//
//  Wind.swift
//  Weather
//
//  Created by helloyako on 2020/04/17.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct Wind: Codable {
    let speed: Double
    let deg: Int
    
    var description: String {
        return "\(degreeToCompass()) \(Int(speed)) m/s"
    }
    
    private func degreeToCompass() -> String {
        let val = Int((Double(deg) / 22.5) + 0.5)
        let arr = ["N","NNE","NE","ENE","E","ESE", "SE", "SSE","S","SSW","SW","WSW","W","WNW","NW","NNW"]
        return arr[(val % 16)]
    }
    
}
