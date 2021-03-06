//
//  WeatherListViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class WeatherListViewController: UIViewController, OpenWeather {
    private var displayModels: [DisplayModel] = []
    private let weatherMaxCount = 20
    
    weak var rootViewController: WeatherRootViewController?

    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
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
                self?.plusButton.isEnabled = false
                self?.rootViewController?.requestWeather(lat: cood.lat, lon: cood.lon)
            }
        }
    }
    
    func checkPlusButton() {
        plusButton.isEnabled = displayModels.count < weatherMaxCount
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateModel(displayModels: [DisplayModel]) {
        self.displayModels = displayModels
        checkPlusButton()
        reloadData()
    }
    
    @IBAction func scaleButtonAction(_ sender: UIButton) {
        celsiusButton.isSelected = !celsiusButton.isSelected
        fahrenheitButton.isSelected = !fahrenheitButton.isSelected
        rootViewController?.toggleScale()
    }
    
    @IBAction func openWeatherButtonAction(_ sender: UIButton) {
        showOpenWeatherSafari()
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell") as? WeatherListTableViewCell else {
            return UITableViewCell()
        }
        let displayModel = displayModels[indexPath.row]
        cell.temperatureLabel.text = displayModel.temperature.toTemperatureDegree(isCelsius: rootViewController?.isCelsius ?? true)
        cell.cityLabel.text = displayModel.name
        cell.dateLabel.text = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + displayModel.timeZone).display
        if displayModel.isCurrentLocation {
            cell.compassImageView.isHidden = false
            cell.dateLabel.isHidden = true
        } else {
            cell.compassImageView.isHidden = true
            cell.dateLabel.isHidden = false
        }
        
        if let icon = displayModel.weather.first?.icon, let image = UIImage(named: icon) {
            cell.backgroundImageView.image = image
        } else {
            cell.backgroundImageView.image = .none
        }
        
        if indexPath.row == 0 {
            cell.centerYConstraint.constant = view.safeAreaInsets.top / 2
        } else {
            cell.centerYConstraint.constant = 0
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        cell.selectedBackgroundView = bgColorView

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        displayModels.remove(at: indexPath.row)
        checkPlusButton()
        rootViewController?.removeWeather(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if displayModels[indexPath.row].isCurrentLocation {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 80
        if indexPath.row == 0 {
            return height + view.safeAreaInsets.top
        } else {
            return height
        }
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rootViewController?.showDetailView(at: indexPath.item)
    }
}
