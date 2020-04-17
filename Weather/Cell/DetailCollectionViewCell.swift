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
    
    func bind(model: DisplayModel, isCelsius: Bool) {
        cityNameLabel.text = model.name
        temperatureLabel.text = model.temperature.toTemperatureDegree(isCelsius: isCelsius)
        weatherNameLabel.text = model.weatherName
        highTemperatureLabel.text = String(model.maxTemperature.toTemperature(isCelsius: isCelsius))
        lowTemperatureLabel.text = String(model.minTemperature.toTemperature(isCelsius: isCelsius))
        
        
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
}

extension DetailCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath)
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
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell") as? DailyTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension DetailCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
