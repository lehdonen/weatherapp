//
//  APIController.swift
//  weatherapp
//
//  Created by Oskari Lehtonen on 25/10/2019.
//  Copyright © 2019 Oskari Lehtonen. All rights reserved.
//

import Foundation

class APIController {
    var currentWeatherCotroller : CurrentWeatherController?
    
    init(){
        
    }
    
    func fetchWeather(url : String, cont: CurrentWeatherController){
        
        currentWeatherCotroller = cont
        
        fecthUrl(url: url)
        
    }
    
    func newLocation(command: String){
        currentWeatherCotroller?.changeLocation(command: command)
    }
    
    func fecthUrl(url: String){
        
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
                    
                    self.fetchWeather(url: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@2x.png", cont: currentWeatherCotroller!)
                    
                    DispatchQueue.main.async(execute: {() in
                        
                        // self.currentWeatherCotroller!.desc.text = weatherData.weather[0].description
                        let formatted = String(format: "%.1f", weatherData.main.temp)
                        self.currentWeatherCotroller!.temperature.text = "  \(formatted) ° C"
                        
                    })
                } catch {
                    print(error)
                }
            }
        }
}
