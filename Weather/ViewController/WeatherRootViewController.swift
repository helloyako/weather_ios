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
    private var isFromBackground = false
    
    private weak var listViewController: WeatherListViewController? = nil
    private weak var detailViewController: WeatherDetailViewController? = nil
    
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    
    
    private var displayModels: [DisplayModel] = []
    private var currentLocationModel: DisplayModel?
    private(set) var isCelsius = true {
        didSet {
            listViewController?.reloadData()
            detailViewController?.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        loadStoredCitiesWeather()
        
        addObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
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
    
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidRBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func loadStoredCitiesWeather() {
        if let ids = getStoredID(), !ids.isEmpty {
            requestCitied(ids: ids)
        }
    }
    
    @objc private func onDidRBecomeActive() {
        guard isFromBackground else {
            return
        }
        isFromBackground = false
        if currentLocationModel != nil {
            locationManager.requestLocation()
        }
        loadStoredCitiesWeather()
    }
    
    @objc private func onDidEnterBackground() {
        isFromBackground = true
    }
    
    private func saveID(id: Int) {
        if var array = getStoredID() {
            if !array.contains(id) {
                array.append(id)
                UserDefaults.standard.set(array, forKey: idsKey)
            }
        } else {
            let array = [id]
            UserDefaults.standard.set(array, forKey: idsKey)
        }
    }
    
    private func getStoredID() -> [Int]? {
        return UserDefaults.standard.array(forKey: idsKey) as? [Int]
    }
    
    private func updateModel() {
        var d = displayModels
        if let cur = currentLocationModel {
            d.insert(cur, at: 0)
        }
        listViewController?.updateModel(displayModels: d)
        detailViewController?.updateModel(displayModels: d)
    }
    
    private func requestCitied(ids: [Int]) {
        WeatherAPI.shared.group(ids: ids) { response in
            switch response {
            case .success(let apiResponse):
                guard let listResponse = apiResponse as? ListResponse else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.displayModels = listResponse.list.map{ $0.convertDisplayModel() }
                    self?.updateModel()
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
                
                var displayModel = weatherResponse.convertDisplayModel()
                if isCurrentLocation {
                    displayModel.isCurrentLocation = true
                    self?.currentLocationModel = displayModel
                } else {
                    self?.saveID(id: weatherResponse.id)
                    self?.displayModels.append(displayModel)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateModel()
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
        var index = index
        if currentLocationModel != nil {
            index = index - 1
        }
        displayModels.remove(at: index)
        
        if var array = getStoredID() {
            array.remove(at: index)
            UserDefaults.standard.set(array, forKey: idsKey)
        }
    }
    
    func showListView() {
        detailContainerView.isHidden = true
        listContainerView.isHidden = false
    }

    func showDetailView(at index: Int) {
        detailContainerView.isHidden = false
        listContainerView.isHidden = true
        detailViewController?.scrollToItem(at: index)
    }
    
}


extension WeatherRootViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .restricted, .denied:
            if let _ = getStoredID() {
                showDetailView(at: 0)
            } else {
                showListView()
            }
        case .notDetermined:
            print("notDetermined")
        default:
            showDetailView(at: 0)
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
