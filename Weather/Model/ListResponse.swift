//
//  ListResponse.swift
//  Weather
//
//  Created by helloyako on 2020/04/16.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

struct ListResponse: Response, Codable {
    let list: [WeatherResponse]
    
}

//struct ListItem: Codable {
//    let id: Int
//    let dt: Int
//    let name: String
//    let main: [Main]
//}
