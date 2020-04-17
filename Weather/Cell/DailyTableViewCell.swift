//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by helloyako on 2020/04/15.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    

    func bind(model: Daily, isCelsius: Bool, timezone: Double) {
        dayLabel.text = CalendarUtil.shared.getWeekday(model.dt + timezone)
        maxTemperatureLabel.text = String(model.temp.max.toTemperature(isCelsius: isCelsius))
        minTemperatureLabel.text = String(model.temp.min.toTemperature(isCelsius: isCelsius))
        iconImageView.image = .none
        if let icon = model.weather.first?.icon {
            iconImageView.loadWeatherIconImage(iconName: icon)
        }
    }
}
