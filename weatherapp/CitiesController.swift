//
//  CitiesController.swift
//  weatherapp
//
//  Created by Oskari Lehtonen on 11/10/2019.
//  Copyright © 2019 Oskari Lehtonen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class CitiesController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableContents = ["Use GPS"]
    var selectedRow : Int?
    var reqController : APIController?
    var locationManager : CLLocationManager?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var city: UITextField!
    
    @IBAction func addCity(_ sender: Any) {
        if let input = city.text {
            if input != "" {
                self.tableContents.append(city.text!)
                tableView.reloadData()
                city.text = ""
            }
        }
    }
    
    @IBAction func removeCity(_ sender: Any) {
        if selectedRow != nil && selectedRow != 0 {
            tableContents.remove(at: selectedRow!)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        UserDefaults.standard.set(tableContents, forKey: "table")
        
        if let city = self.city.text {
            coder.encode(city, forKey: "cityField")
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let array = UserDefaults.standard.stringArray(forKey: "table"){
            tableContents = array
            tableView.reloadData()
        }
        
        if let cityField = coder.decodeObject(forKey: "cityField"){
            self.city.text = cityField as? String
        }
        
        super.decodeRestorableState(with: coder)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        reqController?.newLocation(city: "\(tableContents[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if(tableCell == nil){
            tableCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        
        tableCell!.textLabel!.text = self.tableContents[indexPath.row]
        
        return tableCell!
    }
    
}
