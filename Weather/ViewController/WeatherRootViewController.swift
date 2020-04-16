//
//  WeatherRootViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/15.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class WeatherRootViewController: UIViewController {
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    private weak var listViewController: WeatherListViewController? = nil
    private weak var detailViewController: WeatherDetailViewController? = nil
    
    var weathers: [WeatherResponse] = []
    private(set) var isCelsius = true {
        didSet {
            listViewController?.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailContainerView.isHidden = true
        listContainerView.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherListViewController {
            destination.rootViewController = self
            listViewController = destination
        } else if let destination = segue.destination as? WeatherDetailViewController {
            detailViewController = destination
        }
    }
    
    func requestWeather(lat: Double, lon: Double) {
        WeatherAPI.shared.weather(lat: lat, lon: lon) { response in
            switch response {
            case .success(let apiResponse):
                guard let weatherResponse = apiResponse as? WeatherResponse else {
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.weathers.append(weatherResponse)
                    self?.listViewController?.weathers = self?.weathers ?? []
                    self?.listViewController?.tableView.reloadData()
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    func toggleScale() {
        isCelsius.toggle()
    }
}
