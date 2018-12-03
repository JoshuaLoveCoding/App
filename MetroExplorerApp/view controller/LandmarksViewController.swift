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
    
    var landmarks = [Landmark]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let yelpAPIManager = YelpAPIManager()
        yelpAPIManager.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        yelpAPIManager.fetchStations()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "landmarkCell", for: indexPath) as! LandmarksTableViewCell
        
        let landmark = landmarks[indexPath.row]
        
        cell.landmarkNameLabel.text = landmark.name
        cell.landmarkAddressLabel.text = landmark.address
        
        if(landmark.rating == 0) {
            cell.ratingImage.image = UIImage(named:"regular_0")
        } else if (landmark.rating == 1) {
            cell.ratingImage.image = UIImage(named:"regular_1")
        } else if (landmark.rating == 1.5) {
            cell.ratingImage.image = UIImage(named:"regular_1_half")
        } else if (landmark.rating == 2) {
            cell.ratingImage.image = UIImage(named:"regular_2")
        } else if (landmark.rating == 2.5) {
            cell.ratingImage.image = UIImage(named:"regular_2_half")
        } else if (landmark.rating == 3) {
            cell.ratingImage.image = UIImage(named:"regular_3")
        } else if (landmark.rating == 3.5) {
            cell.ratingImage.image = UIImage(named:"regular_3_half")
        } else if (landmark.rating == 4) {
            cell.ratingImage.image = UIImage(named:"regular_4")
        } else if (landmark.rating == 4.5) {
            cell.ratingImage.image = UIImage(named:"regular_4_half")
        } else if (landmark.rating == 5) {
            cell.ratingImage.image = UIImage(named:"regular_5")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the data to your next view controller
        
        let row = sender as! Int
        
        let vc = segue.destination as! LandmarkDetailViewController
        vc.landmark = landmarks[row]
    }
}

extension LandmarksViewController: FetchLandmarksDelegate {
    func landmarksFound(_ landmarks: [Landmark]) {
        print("landmarks found - here they are in the controller!")
        DispatchQueue.main.async {
            self.landmarks = landmarks
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func landmarksNotFound() {
        print("no landmarks found")
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

