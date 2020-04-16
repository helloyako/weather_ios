//
//  OpenWeather.swift
//  Weather
//
//  Created by helloyako on 2020/04/16.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

protocol OpenWeather {
    func showOpenWeatherSafari()
}

extension OpenWeather {
    func showOpenWeatherSafari() {
        if let url = URL(string: "https://openweathermap.org") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
