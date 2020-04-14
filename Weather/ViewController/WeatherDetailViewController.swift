//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        YahooWeatherAPI.shared.weather(location: "sunnyvale,ca", completionHandler: { result in
            switch result {
            case .success(let response):
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: response.data)
                    print(weatherResponse)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
              print(error.localizedDescription)
            }
        })
    }
}

