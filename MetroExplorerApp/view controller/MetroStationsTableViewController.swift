//
//  StationsTableViewController.swift
//  MetroExplorerApp
//
//  Created by Joshua on 11/24/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit
import MBProgressHUD

class MetroStationsViewController: UITableViewController {
    let wmataAPIManager = WMATAAPIManager()
    
    var stations = [Station]() {
        didSet {
            tableView.reloadData()
        }
    }//reload the stations data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wmataAPIManager.delegate = self
        fetchStation()//fetch stations
    }
    
    private func fetchStation() {
        MBProgressHUD.showAdded(to: self.view, animated: true)//animation appears
        wmataAPIManager.fetchStations()//fetch stations
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }//set the height of the cell
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }//count the number Of rows in stations
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationsTableViewCell
        
        let station = stations[indexPath.row]
        
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
        
        performSegue(withIdentifier: "segueStation", sender: indexPath.row)
    }//use segue to pass station data
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the data to your next view controller
        
        let row = sender as! Int
        
        let vc = segue.destination as! LandmarksViewController
        vc.station = stations[row]//pass stations data
    }
}

extension MetroStationsViewController: FetchStationsDelegate {
    func stationsFound(_ stations: [Station]) {
        print("stations found - here they are in the controller.")
        DispatchQueue.main.async {
            self.stations = stations
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

