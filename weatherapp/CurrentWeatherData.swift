//
//  CurrentWeatherData.swift
//  weatherapp
//
//  Created by Oskari Lehtonen on 25/10/2019.
//  Copyright © 2019 Oskari Lehtonen. All rights reserved.
//

import Foundation

struct CurrentWeatherData : Codable {
    var name : String
    var weather : [Weather]
    var main : Main
}

struct Weather : Codable {
    var main : String
    var description : String
    var icon : String
}

struct Main : Codable {
    var temp : Double
    var pressure: Double;
    var humidity: Double;
}
