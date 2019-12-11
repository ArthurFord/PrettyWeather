//
//  WeatherForecastManager.swift
//  PrettyWeather
//
//  Created by Arthur Ford on 12/10/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherForecastManagerDelegate {
    func didUpdateForecast(forecast: WeatherForecast)
    func didFailWithErrorForecast(error: Error)
}


struct WeatherForecastManager {
    
    var delegate: WeatherForecastManagerDelegate?
    
    let apikey = "appid=d8ba25b889114e9004e1bdab4acab2b5"
    let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
    let units = "imperial"
    let count = "cnt=40"
    
    static let sessionManager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return URLSession(configuration: .default)
    }()
    
    func fetchForecast(_ cityName: String, units: String? = K.imperial) {
        if let url = URL(string: "\(baseURL)?q=\(cityName)&units=\(units!)&\(apikey)&\(count)") {
            performRequest(url: url)
            print(url)
        }
    }
    
    func fetchForecast(_ location: CLLocation, units: String? = K.imperial) {
        if let url = URL(string: "\(baseURL)?lat=\(Int(location.coordinate.latitude))&lon=\(Int(location.coordinate.longitude))&units=\(units!)&\(apikey)") {
            performRequest(url: url)
        }
    }
    
    func performRequest(url: URL) {
        let dataTask = WeatherForecastManager.sessionManager.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithErrorForecast(error: error!)
                return
            }
            
            guard let rawData = data else { return }
            if let weatherForecast = self.parseJSON(rawData: rawData) {
                self.delegate?.didUpdateForecast(forecast: weatherForecast)
            }
        }
        dataTask.resume()
    }
    
    func parseJSON(rawData: Data) -> WeatherForecast? {
        let decoder = JSONDecoder()
        do {
            let weatherForecast = try decoder.decode(WeatherForecast.self, from: rawData)
            return weatherForecast
        } catch  {
            self.delegate?.didFailWithErrorForecast(error: error)
            return nil
        }
    }
}
