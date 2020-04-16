//
//  WeatherListViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class WeatherListViewController: UIViewController, OpenWeather {
    var weathers: [WeatherResponse] = []
    weak var rootViewController: WeatherRootViewController?

    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var fahrenheitButton: UIButton!
    @IBOutlet weak var celsiusButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchViewController {
            destination.completion = { [weak self] cood in
                self?.rootViewController?.requestWeather(lat: cood.lat, lon: cood.lon)
            }
        }
    }
    
    @IBAction func scaleButtonAction(_ sender: UIButton) {
        celsiusButton.isSelected = !celsiusButton.isSelected
        fahrenheitButton.isSelected = !fahrenheitButton.isSelected
        rootViewController?.toggleScale()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction func openWeatherButtonAction(_ sender: UIButton) {
        showOpenWeatherSafari()
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell") as? WeatherListTableViewCell else {
            return UITableViewCell()
        }
        let weather = weathers[indexPath.row]
        cell.temperatureLabel.text = weather.main.temp.toTemperatureDegree(isCelsius: rootViewController?.isCelsius ?? true)
        cell.cityLabel.text = weather.name
        
        
        cell.dateLabel.text = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + weather.timezone).display
        return cell
    }
}
//
//extension WeatherListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//}
