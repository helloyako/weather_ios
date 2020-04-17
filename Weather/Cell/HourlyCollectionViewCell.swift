//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by helloyako on 2020/04/15.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func bind(model: Hourly, isCelsius: Bool, timezone: Double) {
        hourLabel.text = Date(timeIntervalSince1970: model.dt + timezone).displayHourOnlyWithAmPm
        temperatureLabel.text = model.temp.toTemperatureDegree(isCelsius: isCelsius)
        iconImageView.image = .none
        if let icon = model.weather.first?.icon {
            iconImageView.loadWeatherIconImage(iconName: icon)
        }
    }
}
