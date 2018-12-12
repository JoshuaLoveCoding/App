//
//  NearestTableViewController.swift
//  MetroExplorerApp
//
//  Created by Joshua on 12/5/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation

class NearestTableViewController: UITableViewController {
    var appTimer = Timer()
    var lat: Double = 0
    var lon: Double = 0
    let wmataAPIManager = WMATAAPIManager()
    let locationDetector = LocationDetector()//initialize location detector
    
    var stations = [Station]() {
        didSet {
            tableView.reloadData()
        }
    }//reload the stations data
    
    var stationsNew = [Station]() {
        didSet {
            tableView.reloadData()
        }
    }//reload the nearest station
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wmataAPIManager.delegate = self
        locationDetector.delegate = self
        fetchStation()//fetch stations
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appTimer.invalidate()//terminate timer
    }
    
    private func fetchStation() {
        MBProgressHUD.showAdded(to: self.view, animated: true)//animation appears
        locationDetector.findLocation()//fetch location
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }//set the height of the cell
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationsNew.count
    }//count the number Of rows in the nearest station
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationsTableViewCell
        
        let station = stationsNew[indexPath.row]
        
        cell.stationNameLabel.text = station.name
        cell.stationAddressLabel.text = station.address//set data in the view
        
        if station.lineCode1 == "RD" {
            cell.lineCodeImage1.image = UIImage(named:"red.png")
        } else if station.lineCode1 == "BL" {
            cell.lineCodeImage1.image = UIImage(named:"blue.png")
        } else if station.lineCode1 == "GR" {
            cell.lineCodeImage1.image = UIImage(named:"green.png")
        } else if station.lineCode1 == "SV" {
            cell.lineCodeImage1.image = UIImage(named:"grey.png")
        } else if station.lineCode1 == "YL" {
            cell.lineCodeImage1.image = UIImage(named:"yellow.png")
        } else if station.lineCode1 == "OR" {
            cell.lineCodeImage1.image = UIImage(named:"orange.png")
        }//show colour of the line
        
        if station.lineCode2 == "RD" {
            cell.lineCodeImage2.image = UIImage(named:"red.png")
        } else if station.lineCode2 == "BL" {
            cell.lineCodeImage2.image = UIImage(named:"blue.png")
        } else if station.lineCode2 == "GR" {
            cell.lineCodeImage2.image = UIImage(named:"green.png")
        } else if station.lineCode2 == "SV" {
            cell.lineCodeImage2.image = UIImage(named:"grey.png")
        } else if station.lineCode2 == "YL" {
            cell.lineCodeImage2.image = UIImage(named:"yellow.png")
        } else if station.lineCode2 == "OR" {
            cell.lineCodeImage2.image = UIImage(named:"orange.png")
        } else {
            cell.lineCodeImage2.image = UIImage(named:"white.png")//handle line2 doesn't exist
        }//show colour of the line
        
        if station.lineCode3 == "RD" {
            cell.lineCodeImage3.image = UIImage(named:"red.png")
        } else if station.lineCode3 == "BL" {
            cell.lineCodeImage3.image = UIImage(named:"blue.png")
        } else if station.lineCode3 == "GR" {
            cell.lineCodeImage3.image = UIImage(named:"green.png")
        } else if station.lineCode3 == "SV" {
            cell.lineCodeImage3.image = UIImage(named:"grey.png")
        } else if station.lineCode3 == "YL" {
            cell.lineCodeImage3.image = UIImage(named:"yellow.png")
        } else if station.lineCode3 == "OR" {
            cell.lineCodeImage3.image = UIImage(named:"orange.png")
        } else {
            cell.lineCodeImage3.image = UIImage(named:"white.png")//handle line3 doesn't exist
        }//show colour of the line
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segueNearest", sender: indexPath.row)
    }//use segue to pass station data
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the data to your next view controller
        
        let row = sender as! Int
        
        let vc = segue.destination as! LandmarksViewController
        vc.station = stationsNew[row]//pass station data
    }
}

extension NearestTableViewController: LocationDetectorDelegate {
    func locationDetected(latitude: Double, longitude: Double) {
        self.lat = latitude
        self.lon = longitude
        wmataAPIManager.fetchStations()//call fetchStations function
    }
    
    func locationNotDetected() {
        print("no location found :(")
        DispatchQueue.main.async {
            self.appTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: false)//set 10 seconds (timeout)
            //Show a AlertController with error
        }
    }
    @objc func runTimedCode() {
        
        MBProgressHUD.hide(for: self.view, animated: true)//hide animation
        
        let alertController = UIAlertController(title: "Problem getting location", message: "Failed to get location to find nearest station.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alertController.addAction(okayAction)//ok button
        
        self.present(alertController, animated: true, completion: nil)//show alert
    }
}

extension NearestTableViewController: FetchStationsDelegate {
    func stationsFound(_ stations: [Station]) {
        print("stations found - here they are in the controller.")
        DispatchQueue.main.async {
            self.stations = stations
            var dis: Double = 999999999//set Max distance
            var sta = Station(name: "", address: "", lineCode1: "", lineCode2: "", lineCode3: "", lat: -1, lon: -1)//initialize the station
            for ele in stations {
                let len: Double = CLLocation(latitude: ele.lat, longitude: ele.lon).distance(from: CLLocation(latitude: self.lat, longitude: self.lon))
                if len < dis {
                    dis = len
                    sta = ele
                }
            }//calculate the nearest station
            if self.stationsNew.count == 0 {
                self.stationsNew.append(sta)//add the nearest station to the list to show
            }
            MBProgressHUD.hide(for: self.view, animated: true)//hide animation
        }
    }
    
    func stationsNotFound(reason: WMATAAPIManager.FailureReason) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)//hide animation
            
            let alertController = UIAlertController(title: "Problem fetching stations", message: reason.rawValue, preferredStyle: .alert)
            
            switch(reason) {
            case .noResponse:
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    self.fetchStation()
                })//retry button to call function again
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler:nil)//cancel button
                
                alertController.addAction(cancelAction)
                alertController.addAction(retryAction)
                
            case .non200Response, .noData, .badData:
                let okayAction = UIAlertAction(title: "OK", style: .default, handler:nil)
                
                alertController.addAction(okayAction)
            }//ok button
            
            self.present(alertController, animated: true, completion: nil)//show alert
        }
    }
}

