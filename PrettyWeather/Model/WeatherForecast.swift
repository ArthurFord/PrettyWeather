//
//  WeatherForecast.swift
//  PrettyWeather
//
//  Created by Arthur Ford on 12/10/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation
import UIKit

struct WeatherForecast: Decodable {
    let list: [Forecast]
    let city: City
}

struct Forecast: Decodable {
    let dt: Int
    
    let main: Main
    let weather: [BasicWeather]
    
    var minTemperatureString: String {
        return String(format: "%.0f", main.temp_min) + "℉"
    }
    
    var maxTemperatureString: String {
        return String(format: "%.0f", main.temp_max) + "℉"
    }
    
    var conditionName: String {
        switch weather[0].id {
        case 200...299:
            return conditions.thunderstorm.rawValue
        case 300...399:
            return conditions.drizzle.rawValue
        case 500...599:
            return conditions.rain.rawValue
        case 600...699:
            return conditions.snow.rawValue
        case 800:
            return conditions.clear.rawValue
        case 801...899:
            return conditions.clouds.rawValue
        default:
            return conditions.other.rawValue
        }
    }
}



struct City: Decodable {
    let name: String
    let country: String
}

