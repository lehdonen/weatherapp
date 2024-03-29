//
//  CurrentWeatherController.swift
//  weatherapp
//
//  Created by Oskari Lehtonen on 11/10/2019.
//  Copyright © 2019 Oskari Lehtonen. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherController : UIViewController {
    var reqController : APIController?
    var geoCoder = CLGeocoder()
    var APPID = "1926fe0ba26221588265e05596d1c0e3"

    var location : CLLocationCoordinate2D?
    var locationManager : CLLocationManager?
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var weatherIMG: UIImageView!
    @IBOutlet weak var temperature: UILabel!

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.city.text, forKey: "city")
        coder.encode(self.desc.text, forKey: "desc")
        coder.encode(self.temperature.text, forKey: "temperature")
        coder.encode(self.weatherIMG.image, forKey: "weatherImage")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        let city = coder.decodeObject(forKey: "placeName") as? String
        let temperature = coder.decodeObject(forKey: "temp") as? String
        let description = coder.decodeObject(forKey: "desc") as? String
        let weatherIMG = coder.decodeObject(forKey: "weatherImage") as? UIImage
        
        if  let cityString = city,
            let descString = description,
            let tempString = temperature,
            let IMG = weatherIMG 
        {
            self.city.text = cityString
            self.desc.text = descString
            self.temperature.text = tempString
            self.weatherIMG.image = IMG
        }

        super.decodeRestorableState(with: coder)
    }
 
    func setLocation(location : CLLocationCoordinate2D, place : CLPlacemark){
        self.location = location
        self.city.text = place.locality!
        reqController!.fetchWeather(URL: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&APPID=1926fe0ba26221588265e05596d1c0e3", controller: self)
    }
    
    func newLocation(input: String){
        if (input == "Use GPS") {
            locationManager?.startUpdatingLocation()
        } else {
            self.city.text = input
            reqController!.fetchWeather(URL: "https://api.openweathermap.org/data/2.5/weather?q=\(input)&units=metric&APPID=1926fe0ba26221588265e05596d1c0e3", controller: self)
        }
    }
}
