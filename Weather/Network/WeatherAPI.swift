//
//  WeatherAPI.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

protocol Response {}

enum APIResponse {
    case success(Response)
    case error(Error)
}

enum APIError: Error {
    case unknown
}

class WeatherAPI {
    static let shared = WeatherAPI()
    private init() { }
    
    private let apiKey = "78e16436406fb05abbf0d9489d91200c"
    private let base = "https://api.openweathermap.org/data/2.5"
    private let defaultSession = URLSession(configuration: .default)
    let cache = URLCache.shared
    
    func oneCall(lat: Double, lon: Double, completion: ((APIResponse)->())? = nil) {
        let path = "onecall"
        let queryParameter = makeQueryParameter(lat: lat, lon: lon)
        guard let url = URL(string: "\(base)/\(path)?lat=\(lat)&\(queryParameter)") else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = defaultSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion?(.error(error))
                } else {
                    completion?(.error(APIError.unknown))
                }
                return
            }
            
            do {
                let oneCallResponse = try JSONDecoder().decode(OneCallResponse.self, from: data)
                completion?(.success(oneCallResponse))
            } catch let error {
                completion?(.error(error))
            }

        }
        
        dataTask.resume()
    }
    
    func weather(lat: Double, lon: Double, completion: ((APIResponse)->())? = nil) {
        let path = "weather"
        let queryParameter = makeQueryParameter(lat: lat, lon: lon)
        guard let url = URL(string: "\(base)/\(path)?\(queryParameter)") else {
            return
        }
        let request = URLRequest(url: url)
        
        let dataTask = defaultSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion?(.error(error))
                } else {
                    completion?(.error(APIError.unknown))
                }
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion?(.success(weatherResponse))
            } catch let error {
                completion?(.error(error))
            }

        }
        
        dataTask.resume()
    }
    
    func group(ids: [Int], completion: ((APIResponse)->())? = nil) {
        let path = "group"
        let idsValue = ids.map { String($0) }.joined(separator: ",")
        let queryParameter = "id=\(idsValue)&units=metric&\(commonParameter)"
        guard let url = URL(string: "\(base)/\(path)?\(queryParameter)") else {
            return
        }
        let request = URLRequest(url: url)
        
        let dataTask = defaultSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion?(.error(error))
                } else {
                    completion?(.error(APIError.unknown))
                }
                return
            }
            
            do {
                let listResponse = try JSONDecoder().decode(ListResponse.self, from: data)
                completion?(.success(listResponse))
            } catch let error {
                completion?(.error(error))
            }

        }
        
        dataTask.resume()
        
    }
    
    func loadWeatherIconImage(iconName name: String, completion: ((UIImage)->())? = nil) {
        let url = "http://openweathermap.org/img/wn/\(name)@2x.png"
        guard let imageURL = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: imageURL)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            completion?(image)
        } else {
            let dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
                if let data = data, let response = response, let image = UIImage(data: data) {
                    let cacheData = CachedURLResponse(response: response, data: data)
                    self?.cache.storeCachedResponse(cacheData, for: request)
                    completion?(image)
                }
            }
            dataTask.resume()
        }
    }
    
    
    private func makeQueryParameter(lat: Double, lon: Double) -> String {
        return "lat=\(lat)&lon=\(lon)&\(commonParameter)"
    }
    
    private var commonParameter: String {
        return "appid=\(apiKey)&units=metric"
    }
}
