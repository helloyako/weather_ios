//
//  WeatherAPI.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

class WeatherAPI {
    static let shared = WeatherAPI()
    private init() { }
    
    private let apiKey = "78e16436406fb05abbf0d9489d91200c"
    private let base = "https://api.openweathermap.org/data/2.5"
    private let defaultSession = URLSession(configuration: .default)
    
    func detail(lat: Double, lon: Double) {
        let path = "onecall"
        guard let url = URL(string: "\(base)/\(path)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = defaultSession.dataTask(with: request) { data, response, error in
            
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data!)
                print(weatherResponse)
            } catch let error {
                print(error.localizedDescription)
            }

        }
        
        dataTask.resume()
    }
    
}
