//
//  Weather.swift
//  PrettyWeather
//
//  Created by Arthur Ford on 12/10/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation
import UIKit

struct WeatherObject: Decodable {
    let name: String
    let main: Main
    let weather: [BasicWeather]
    let sys: Sys
    
    var temperatureString: String {
        return String(format: "%.0f", main.temp) + "℉"
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

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct BasicWeather: Decodable {
    let id: Int
    let description: String
}

struct Sys: Decodable {
    let country: String
}


