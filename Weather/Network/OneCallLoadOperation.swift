//
//  OneCallLoadOperation.swift
//  Weather
//
//  Created by helloyako on 2020/04/17.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation


class OneCallLoadOperation: Operation {
    var oneCallResponse: OneCallResponse?
    var loadingCompleteHandler: ((OneCallResponse) ->Void)?
    let lat: Double
    let lon: Double
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    override func main() {
        if isCancelled { return }
        WeatherAPI.shared.oneCall(lat: lat, lon: lon) { [weak self] response in
            switch response {
            case .success(let apiResponse):
                guard let oneCallResponse = apiResponse as? OneCallResponse, let self = self else {
                    return
                }
                if self.isCancelled { return }
                self.oneCallResponse = oneCallResponse
                DispatchQueue.main.async { [weak self] in
                    self?.loadingCompleteHandler?(oneCallResponse)
                }
            case .error(let error):
                print("onCall api error \(error)")
            }
        }
    }
}
