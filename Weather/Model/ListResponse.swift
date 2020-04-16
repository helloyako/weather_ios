//
//  ListResponse.swift
//  Weather
//
//  Created by helloyako on 2020/04/16.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct ListResponse: Response, Codable {
    let list: [ListItem]
    
}

struct ListItem: Codable {
    let id: Int
    let dt: Double
    let name: String
    let sys: Sys
    let main: Main
    let coord: Coord
    
    func convertDisplayModel() -> DisplayModel {
        return DisplayModel(coord: coord, temperature: main.temp, name: name, timeZone: sys.timezone)
    }
    
    struct Sys: Codable {
        let timezone: Double
    }
}


