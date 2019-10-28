//
//  APIController.swift
//  weatherapp
//
//  Created by Oskari Lehtonen on 25/10/2019.
//  Copyright © 2019 Oskari Lehtonen. All rights reserved.
//

import Foundation
import UIKit

class APIController {
    var currentWeatherController : CurrentWeatherController?
    
    init(){
        
    }
    
    func fetchWeather(URL : String, controller: CurrentWeatherController){
        currentWeatherController = controller
        fetchURL(url: URL)
    }
    
    func newLocation(city: String){
        currentWeatherController?.newLocation(input: city)
    }
    
    func fetchURL(url: String){
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        if let resstr = String(data: data!, encoding: String.Encoding.utf8){
                do{
                    let weatherData = try JSONDecoder().decode(CurrentWeatherData.self, from:data!)
                    
                    self.fetchWeather(URL: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@2x.png", controller: currentWeatherController!)
                    
                    DispatchQueue.main.async(execute: {() in
                        
                        self.currentWeatherController!.temperature.text = "  \(weatherData.main.temp) ° C"
                        self.currentWeatherController!.desc.text = " \(weatherData.weather[0].description)"
                    })
                } catch {
                    print(error)
                }
        } else if let img = UIImage(data: data!) {
            DispatchQueue.main.async(execute: {() in
                self.currentWeatherController?.weatherIMG.image = img
            })
        }
    }
}
