//
//  DetailCollectionViewCell.swift
//  Weather
//
//  Created by helloyako on 2020/04/15.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var compassImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherNameLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var uviLabel: UILabel!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            tableViewHeightConstraint.constant = 50 * 8
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private var hourly: [Hourly] = []
    private var dailly: [Daily] = []
    var isCelsius = true
    var timezone: Double = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hourly.removeAll()
        dailly.removeAll()
        timezone = 0
        isCelsius = true
        
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func bind(model: DisplayModel, isCelsius: Bool) {
        self.isCelsius = isCelsius
        timezone = model.timeZone
        cityNameLabel.text = model.name
        temperatureLabel.text = model.temperature.toTemperatureDegree(isCelsius: isCelsius)
        weatherNameLabel.text = model.weatherName
        highTemperatureLabel.text = String(model.maxTemperature.toTemperature(isCelsius: isCelsius))
        lowTemperatureLabel.text = String(model.minTemperature.toTemperature(isCelsius: isCelsius))
        let timestamp = Date().timeIntervalSince1970 + model.timeZone
        weekdayLabel.text = CalendarUtil.shared.getWeekday(timestamp)
        
        sunriseLabel.text = Date(timeIntervalSince1970: model.sunrise + model.timeZone).displayAmPm
        sunsetLabel.text = Date(timeIntervalSince1970: model.sunset + model.timeZone).displayAmPm
        humidityLabel.text = "\(model.humidity)%"
        windLabel.text = model.wind.description
        feelsLikeLabel.text = model.feelsLike.toTemperatureDegree(isCelsius: isCelsius)
        pressureLabel.text = "\(model.pressure)hPa"
        visibilityLabel.text = "\(model.visibility)m"
        
        if let precipitation = model.precipitation {
            precipitationLabel.text = "\(precipitation)mm"
        } else {
            precipitationLabel.text = "0mm"
        }
        
        compassImageView.isHidden = !model.isCurrentLocation
    }
    
    func updateExtraData(model: OneCallResponse) {
        uviLabel.text = String(model.current.uvi)
        if hourly.isEmpty {
            hourly = model.hourly
            collectionView.reloadData()
        }
        
        if dailly.isEmpty {
            dailly = model.daily
            tableView.reloadData()
        }
    }
}

extension DetailCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath)
        if let hourlyCell = cell as? HourlyCollectionViewCell {
            hourlyCell.bind(model: hourly[indexPath.item], isCelsius: isCelsius, timezone: timezone)
        }
        return cell
    }
    
    
}

extension DetailCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: collectionView.frame.height)
    }
}

extension DetailCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailly.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell") as? DailyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.bind(model: dailly[indexPath.item], isCelsius: isCelsius, timezone: timezone)
        
        return cell
    }
}

extension DetailCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
