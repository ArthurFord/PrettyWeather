//
//  K.swift
//  PrettyWeather
//
//  Created by Arthur Ford on 12/10/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation

struct K {
    static let mainScreenCellID = "mainScreenCell"
    static let settingsSegueID = "settingsSegue"
    static let locationsSegueID = "locationsSegue"
    static let celsius = "metric"
    static let imperial = "imperial"
    
    struct Defaults {
        static let color = "color"
        static let units = "units"
    }
    
    struct Colors {
        static let color00A0C1 = "00A0C1"
        static let color00AC1F = "00AC1F"
        static let color0B3E9E = "0B3E9E"
        static let color00BAEE = "00BAEE"
        static let color0039AF = "0039AF"
        static let color80ADDF = "80ADDF"
        static let color0086E4 = "0086E4"
        static let colorFF6B0A = "FF6B0A"
        
        static let color00A0C1Sel = "00A0C1Sel"
        static let color00AC1FSel = "00AC1FSel"
        static let color0B3E9ESel = "0B3E9ESel"
        static let color00BAEESel = "00BAEESel"
        static let color0039AFSel = "0039AFSel"
        static let color80ADDFSel = "80ADDFSel"
        static let color0086E4Sel = "0086E4Sel"
        static let colorFF6B0ASel = "FF6B0ASel"
    }
}

enum conditions: String {
    case thunderstorm = "cloud.bolt.rain"
    case drizzle = "cloud.sun.rain"
    case rain = "cloud.rain"
    case snow = "cloud.snow"
    case clear = "sun.max"
    case clouds = "cloud"
    case other = "thermometer"
}
