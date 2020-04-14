//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailViewController: UIViewController {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    private func requestWeatherAPI(lat: Double, lon: Double) {
        YahooWeatherAPI.shared.weather(lat: String(lat), lon: String(lon), completionHandler: { result in
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

extension WeatherDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .restricted, .denied, .notDetermined:
            print("you should allow permission")
        default:
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let last = locations.last {
            requestWeatherAPI(lat: last.coordinate.latitude, lon: last.coordinate.longitude)
        } else {
            print("something wrong")
        }
    }
    
}
