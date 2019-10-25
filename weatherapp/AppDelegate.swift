//
//  AppDelegate.swift
//  weatherapp
//
//  Created by Oskari Lehtonen on 11/10/2019.
//  Copyright © 2019 Oskari Lehtonen. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var reqController : APIController?
    var locationManager : CLLocationManager?
    var geoCoder = CLGeocoder()

    var currentWeatherController : CurrentWeatherController?
    var forecastController : ForecastController?
    var citiesController : CitiesController?
        
    var locationCoord : CLLocationCoordinate2D?
    var location : CLLocation?
    var placeMark: CLPlacemark?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarController = window?.rootViewController as! UITabBarController
        
        currentWeatherController = tabBarController.viewControllers![0] as! CurrentWeatherController
        forecastController = tabBarController.viewControllers![1] as! ForecastController
        citiesController = tabBarController.viewControllers![2] as! CitiesController
        
        reqController = APIController()
        
        currentWeatherController?.reqController = self.reqController
        
        self.locationManager = CLLocationManager()
        currentWeatherController?.locationManager = self.locationManager
        self.locationManager!.delegate = self
        locationManager!.requestAlwaysAuthorization()
        self.locationManager!.startUpdatingLocation()
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationCoord = self.locationManager?.location?.coordinate
        self.location = CLLocation(latitude: (self.locationCoord?.latitude)!, longitude: (self.locationCoord?.longitude)!)
        
        geoCoder.reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            var place: CLPlacemark!
            place = placemarks?[0]

            self.placeMark = placemarks?[0]
            self.currentWeatherController?.setLocation(loc: self.locationCoord!, place: place)
        })
        
        self.locationManager!.stopUpdatingLocation()
    }
    
    func newLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

