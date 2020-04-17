//
//  WeatherRootViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/15.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherRootViewController: UIViewController {
    private let idsKey = "ids"
    private let locationManager = CLLocationManager()
    
    private weak var listViewController: WeatherListViewController? = nil
    private weak var detailViewController: WeatherDetailViewController? = nil
    
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    
    
    var displayModels: [DisplayModel] = []
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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if let ids = UserDefaults.standard.array(forKey: idsKey) as? [Int] {
            requestCitied(ids: ids)
        } else {
            print("nonono")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherListViewController {
            destination.rootViewController = self
            listViewController = destination
        } else if let destination = segue.destination as? WeatherDetailViewController {
            destination.rootViewController = self
            detailViewController = destination
        }
    }
    
    private func saveID(id: Int) {
        if var array = UserDefaults.standard.array(forKey: idsKey) as? [Int] {
            if !array.contains(id) {
                array.append(id)
                UserDefaults.standard.set(array, forKey: idsKey)
            }
        } else {
            let array = [id]
            UserDefaults.standard.set(array, forKey: idsKey)
        }
    }
    
    func requestCitied(ids: [Int]) {
        WeatherAPI.shared.group(ids: ids) { response in
            switch response {
            case .success(let apiResponse):
                guard let listResponse = apiResponse as? ListResponse else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.displayModels.append(contentsOf: listResponse.list.map{ $0.convertDisplayModel() })
                    if let displayModels = self?.displayModels {
                        self?.listViewController?.updateModel(displayModels: displayModels)
                    }
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    func requestWeather(lat: Double, lon: Double, isCurrentLocation: Bool = false) {
        WeatherAPI.shared.weather(lat: lat, lon: lon) { [weak self] response in
            switch response {
            case .success(let apiResponse):
                guard let weatherResponse = apiResponse as? WeatherResponse else {
                    return
                }
                
                let displayModel = weatherResponse.convertDisplayModel()
                if isCurrentLocation {
                    self?.displayModels.insert(displayModel, at: 0)
                } else {
                    self?.saveID(id: weatherResponse.id)
                    self?.displayModels.append(displayModel)
                }
                
                DispatchQueue.main.async { [weak self] in
                    if let displayModels = self?.displayModels {
                        self?.listViewController?.updateModel(displayModels: displayModels)
                        self?.detailViewController?.updateModel(displayModels: displayModels)
                    }
                }
            case .error(let error):
                self?.listViewController?.checkPlusButton()
                print(error)
            }
        }
    }
    
    func requestOneCall(lat: Double, lon: Double) {
        WeatherAPI.shared.oneCall(lat: lat, lon: lon) { response in
            
        }
    }
    
    func toggleScale() {
        isCelsius.toggle()
    }
    
    func removeWeather(at index: Int) {
        displayModels.remove(at: index)
        if var array = UserDefaults.standard.array(forKey: idsKey) as? [Int] {
            array.remove(at: index)
            UserDefaults.standard.set(array, forKey: idsKey)
        }
    }
    
    func showListView() {
        detailContainerView.isHidden = true
        listContainerView.isHidden = false
    }

    func showDetailView() {
        detailContainerView.isHidden = false
        listContainerView.isHidden = true
    }
    
}


extension WeatherRootViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .restricted, .denied:
            print("you should allow permission")
            showListView()
        case .notDetermined:
            print("notDetermined")
        default:
            print("greate!!")
            showDetailView()
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let last = locations.last {
            requestWeather(lat: last.coordinate.latitude, lon: last.coordinate.longitude, isCurrentLocation: true)
        } else {
            print("something wrong")
        }
    }
    
}
