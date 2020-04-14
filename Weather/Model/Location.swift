//
//  Location.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct Location: Codable {
    let woeid: Int
    let city: String
    let region: String
    let country: String
    let lat: Double
    let long: Double
}
