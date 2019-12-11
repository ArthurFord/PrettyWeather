//
//  WeatherManager.swift
//  PrettyWeather
//
//  Created by Arthur Ford on 12/10/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherObject)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let apikey = "appid=d8ba25b889114e9004e1bdab4acab2b5"
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    
    static let sessionManager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return URLSession(configuration: .default)
    }()
    
    func fetchWeather(_ cityName: String, units: String? = K.imperial) {
        if let url = URL(string: "\(baseURL)?q=\(cityName)&units=\(units!)&\(apikey)") {
            performRequest(url: url)
            print(url)
        }
    }
    
    func fetchWeather(_ location: CLLocation, units: String? = K.imperial) {
        if let url = URL(string: "\(baseURL)?lat=\(Int(location.coordinate.latitude))&lon=\(Int(location.coordinate.longitude))&units=\(units!)&\(apikey)") {
            performRequest(url: url)
        }
    }

    func performRequest(url: URL) {
        let dataTask = WeatherManager.sessionManager.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            guard let rawData = data else { return }
            if let weatherObject = self.parseJSON(rawData: rawData) {
                self.delegate?.didUpdateWeather(weather: weatherObject)
            }
        }
        dataTask.resume()
    }
    
    func parseJSON(rawData: Data) -> WeatherObject? {
        let decoder = JSONDecoder()
        do {
            let weatherObject = try decoder.decode(WeatherObject.self, from: rawData)
            return weatherObject
        } catch  {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
