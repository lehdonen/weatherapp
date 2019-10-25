//
//  CurrentWeatherController.swift
//  weatherapp
//
//  Created by Oskari Lehtonen on 11/10/2019.
//  Copyright © 2019 Oskari Lehtonen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class CurrentWeatherController : UIViewController {
    var reqController : APIController?
    var geoCoder = CLGeocoder()
    var location : CLLocationCoordinate2D?
    var locationManager : CLLocationManager?
    var APPID = "1926fe0ba26221588265e05596d1c0e3"
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var weatherIMG: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        
        coder.encode(self.city.text, forKey: "placeName")
        coder.encode(self.temperature.text, forKey: "temp")
        // coder.encode(self.description.text, forKey: "description")
        coder.encode(self.weatherIMG.image, forKey: "weatherImage")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        let city = coder.decodeObject(forKey: "placeName") as? String
        let temperature = coder.decodeObject(forKey: "temp") as? String
        // let description = coder.decodeObject(forKey: "description") as? String
        let weatherIMG = coder.decodeObject(forKey: "weatherImage") as? UIImage
        
        if let cityText = city,
            let tempText = temperature,
            let IMG = weatherIMG{
            self.city.text = cityText
            self.temperature.text = tempText
            self.weatherIMG.image = IMG
        }
        super.decodeRestorableState(with: coder)
    }
    
    func setLocation(loc : CLLocationCoordinate2D, place : CLPlacemark){
        self.location = loc
        self.city.text = place.locality!
        reqController!.fetchWeather(url: "https://api.openweathermap.org/data/2.5/weather?lat=\(loc.latitude)&lon=\(loc.longitude)&units=metric&APPID=" + APPID,cont: self)
    }
    
    func changeLocation(command: String){
        if(command == "Use GPS") {
            locationManager?.startUpdatingLocation()
        }
        else {
            let str = command
            let replaced = str.replacingOccurrences(of: " ", with: "+")
            self.city.text = command
            reqController!.fetchWeather(url: "https://api.openweathermap.org/data/2.5/weather?q=\(replaced)&units=metric&APPID=" + APPID,cont: self)
        }
    }
}
