//
//  NearestTableViewController.swift
//  MetroExplorerApp
//
//  Created by Joshua on 11/24/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit
import MBProgressHUD

class LandmarksViewController: UITableViewController {
    var favorites = PersistenceManager.sharedInstance.fetchFavorites()
    var lat: Double = 0
    var lon: Double = 0
    let yelpAPIManager = YelpAPIManager()
    var station = Station(name: "", address: "", lineCode1: "", lineCode2: "", lineCode3: "", lat: 0, lon: 0)//initialize the station
    
    var landmarks = [Landmark]() {
        didSet {
            tableView.reloadData()
        }
    }//reload the landmarks data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title == "Landmarks" {
            self.navigationItem.title = station.name//show landmarks view title
            self.lat = station.lat
            self.lon = station.lon
            yelpAPIManager.delegate = self
            fetchLandmark()//use latitude and longitude to fetch landmark
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favorites = PersistenceManager.sharedInstance.fetchFavorites()
        tableView.reloadData()//make sure the favorites view will be updated
    }
    
    private func fetchLandmark() {
        MBProgressHUD.showAdded(to: self.view, animated: true)//animation appears
        yelpAPIManager.fetchLandmarks(lat: self.lat, lon: self.lon)//use latitude and longitude to fetch landmark
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }//set the height of the cell
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if self.title == "Landmarks" {
            count = landmarks.count//count the number Of rows in landmarks
        } else {
            count = favorites.count//count the number Of rows in favorites
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        //show landmarks data
        if self.title == "Landmarks" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "landmarkCell", for: indexPath) as! LandmarksTableViewCell
            
            let landmark = landmarks[indexPath.row]
            
            cell.landmarkNameLabel.text = landmark.name
            cell.landmarkAddressLabel.text = landmark.address//set data in the view
            
            var urlString:String = ""
            urlString = landmark.image_url
            if let url = URL(string: urlString) {
                cell.landmarkImage.load(url: url)
            } else {
                cell.landmarkImage.image = UIImage(named: "no_image_available")
            }//handle when url doesn't exist
            cellToReturn = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritesTableViewCell
            
            let favorite = favorites[indexPath.row]
            
            cell.favoriteNameLabel.text = favorite.name
            cell.favoriteAddressLabel.text = favorite.address//set data in the view
            
            var urlString:String = ""
            urlString = favorite.image_url
            if let url = URL(string: urlString) {
                cell.favoriteImage.load(url: url)
            } else {
                cell.favoriteImage.image = UIImage(named: "no_image_available")
            }//handle when url doesn't exist
            cellToReturn = cell
        }//show favorites data
        return cellToReturn
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //use segue to pass landmarks data
        if self.title == "Landmarks" {
            performSegue(withIdentifier: "segue", sender: indexPath.row)
        } else {
            performSegue(withIdentifier: "segueFavorites", sender: indexPath.row)
        }//use segue to pass favorites data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the data to your next view controller
        
        let row = sender as! Int
        
        let vc = segue.destination as! LandmarkDetailViewController
        if self.title == "Landmarks" {
            vc.landmark = landmarks[row]//pass landmarks data
        } else {
            vc.landmark = favorites[row]//pass favorites data
        }
    }
}

extension LandmarksViewController: FetchLandmarksDelegate {
    func landmarksFound(_ landmarks: [Landmark]) {
        print("landmarks found - here they are in the controller.")
        DispatchQueue.main.async {
            self.landmarks = landmarks
            MBProgressHUD.hide(for: self.view, animated: true)//hide animation
        }
    }
    
    func landmarksNotFound(reason: YelpAPIManager.FailureReason) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)//hide animation
            let alertController = UIAlertController(title: "Problem fetching landmarks", message: reason.rawValue, preferredStyle: .alert)
            
            switch(reason) {
            case .noResponse:
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    self.fetchLandmark()
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

