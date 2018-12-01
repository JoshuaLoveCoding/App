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
    
    var stations = [Station]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wmataAPIManager = WMATAAPIManager()
        wmataAPIManager.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        wmataAPIManager.fetchStations()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationsTableViewCell
        
        let station = stations[indexPath.row]
        
        cell.stationNameLabel.text = station.name
        cell.stationAddressLabel.text = station.address
        
        return cell
    }
}

extension MetroStationsViewController: FetchStationsDelegate {
    func stationsFound(_ stations: [Station]) {
        print("stations found - here they are in the controller!")
        DispatchQueue.main.async {
            self.stations = stations
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func stationsNotFound() {
        print("no stations found")
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
