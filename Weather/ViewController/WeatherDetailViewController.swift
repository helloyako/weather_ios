//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit
import OAuthSwift

class WeatherDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        YahooWeatherAPI.shared.weather(location: "sunnyvale,ca", completionHandler: { result in
            switch result {
            case .success(let response):
                try? print(response.jsonObject())
            case .failure(let error):
              print(error.localizedDescription)
            }
        })
    }
}

