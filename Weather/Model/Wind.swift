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
    let deg: Int?
    
    var description: String {
        return "\(degreeToCompass()) \(Int(speed)) m/s"
    }
    
    private func degreeToCompass() -> String {
        guard let deg = deg else {
            return ""
        }
        let val = Int((Double(deg) / 22.5) + 0.5)
        let string = NSLocalizedString("cardinal_points", comment: "")
        let array = string.split(separator: ",").map { String($0) }
        return array[(val % array.count)]
    }
    
}
