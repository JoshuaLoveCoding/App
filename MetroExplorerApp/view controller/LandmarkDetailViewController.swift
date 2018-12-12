//
//  LandmarkDetailViewController.swift
//  MetroExplorerApp
//
//  Created by Joshua on 11/26/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit
import MapKit

class LandmarkDetailViewController: UIViewController {
    
    var landmark = Landmark(name: "", address: "", image_url: "", rating: -1, latitude: 0, longitude: 0)//initialize the landmark
    var urlString:String = ""
    var have : Bool = false
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var landmarkAddressLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        let shareText = "Check out this landmark: \(landmark.name). Address: \(landmark.address ?? "") \(landmark.image_url)"//set shared content
        
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }//share button
    
    @IBAction func showMeWhere(_ sender: Any)
    {
        //Defining destination
        let latitude:CLLocationDegrees = landmark.latitude
        let longitude:CLLocationDegrees = landmark.longitude
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)//set destination view
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeTransit,
                       MKLaunchOptionsShowsTrafficKey: true] as [String : Any]//set mode to public transportation
        
        let placemark = MKPlacemark(coordinate: coordinates)//mark the place
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = landmark.name
        mapItem.openInMaps(launchOptions: options)
    }//map button
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        let name = landmark.name
        let address = landmark.address
        let image_url = landmark.image_url
        let rating = landmark.rating
        let latitude = landmark.latitude
        let longitude = landmark.longitude
        
        let landmarks = Landmark(name: name, address: address, image_url: image_url, rating: rating, latitude: latitude, longitude: longitude)//initialize and set the landmark
        
        if have == false {
            createAlert(title: "Notice", message: "\(landmark.name) has been added to favorites")
            favoriteButton.image = UIImage(named:"heart_filled")//show filled heart in the favorites list
        } else {
            createAlert(title: "Notice", message: "\(landmark.name) has been removed from favorites")
            favoriteButton.image = UIImage(named:"heart")//item removed from the favorites list to show unfilled heart
        }
        PersistenceManager.sharedInstance.saveFavorite(landmark: landmarks)
    }//favorite button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = landmark.name
        
        nameLabel?.text = landmark.name
        landmarkAddressLabel?.text = landmark.address//set data in the view
        
        urlString = landmark.image_url
        if let url = URL(string: urlString) {
            urlImage.load(url: url)
        } else {
            urlImage.image = UIImage(named: "no_image_available")
        }//handle when url doesn't exist
        
        if landmark.rating == 0 {
            ratingImage.image = UIImage(named:"regular_0")
        } else if landmark.rating == 1 {
            ratingImage.image = UIImage(named:"regular_1")
        } else if landmark.rating == 1.5 {
            ratingImage.image = UIImage(named:"regular_1_half")
        } else if landmark.rating == 2 {
            ratingImage.image = UIImage(named:"regular_2")
        } else if landmark.rating == 2.5 {
            ratingImage.image = UIImage(named:"regular_2_half")
        } else if landmark.rating == 3 {
            ratingImage.image = UIImage(named:"regular_3")
        } else if landmark.rating == 3.5 {
            ratingImage.image = UIImage(named:"regular_3_half")
        } else if landmark.rating == 4 {
            ratingImage.image = UIImage(named:"regular_4")
        } else if landmark.rating == 4.5 {
            ratingImage.image = UIImage(named:"regular_4_half")
        } else if landmark.rating == 5 {
            ratingImage.image = UIImage(named:"regular_5")
        }//show rating picture
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let favorites = PersistenceManager.sharedInstance.fetchFavorites()
        for ele in favorites {
            if ele.address == landmark.address {
                have = true
                break
            }
        }//to check if the current item is in the favorites list
        if have == false {
            favoriteButton.image = UIImage(named:"heart")
        } else {
            favoriteButton.image = UIImage(named:"heart_filled")
        }//show favorite button unfilled or filled heart
    }
    
    func createAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("OK")
        }))//ok button
        
        self.present(alert, animated: true, completion: nil)//show alert
    }
    
}
