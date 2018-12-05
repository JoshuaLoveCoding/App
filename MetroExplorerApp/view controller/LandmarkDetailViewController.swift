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
    
    var landmark = Landmark(name: "", address: "", image_url: "", rating: -1, latitude: 0, longitude: 0)
    var urlString:String = ""
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var landmarkAddressLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        let shareText = "Check out this landmark: \(landmark.name)! Address: \(landmark.address!) \(landmark.image_url)"
        
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func showMeWhere(_ sender: Any)
    {
        //Defining destination
        let latitude:CLLocationDegrees = landmark.latitude
        let longitude:CLLocationDegrees = landmark.longitude
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = landmark.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        let name = landmark.name
        let address = landmark.address
        let image_url = landmark.image_url
        let rating = landmark.rating
        let latitude = landmark.latitude
        let longitude = landmark.longitude
        
        let landmarks = Landmark(name: name, address: address, image_url: image_url, rating: rating, latitude: latitude, longitude: longitude)
        let favorites = PersistenceManager.sharedInstance.fetchFavorites()
        var have : Bool = false
        for ele in favorites {
            if (ele.address == landmark.address) {
                have = true
                break
            }
        }
        if (have != true) {
            createAlert(title: "Notice", message: "\(landmark.name) has been added to favorites")
        } else {
            createAlert(title: "Notice", message: "\(landmark.name) has been removed from favorites")
        }
        PersistenceManager.sharedInstance.saveFavorite(landmark: landmarks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel?.text = landmark.name
        landmarkAddressLabel?.text = landmark.address
        
        urlString = landmark.image_url
        let url = URL(string: urlString)
        if (url != nil) {
            urlImage.load(url: url!)
        } else {
            urlImage.image = UIImage(named: "no_image_available")
        }
        
        if(landmark.rating == 0) {
            ratingImage.image = UIImage(named:"regular_0")
        } else if (landmark.rating == 1) {
            ratingImage.image = UIImage(named:"regular_1")
        } else if (landmark.rating == 1.5) {
            ratingImage.image = UIImage(named:"regular_1_half")
        } else if (landmark.rating == 2) {
            ratingImage.image = UIImage(named:"regular_2")
        } else if (landmark.rating == 2.5) {
            ratingImage.image = UIImage(named:"regular_2_half")
        } else if (landmark.rating == 3) {
            ratingImage.image = UIImage(named:"regular_3")
        } else if (landmark.rating == 3.5) {
            ratingImage.image = UIImage(named:"regular_3_half")
        } else if (landmark.rating == 4) {
            ratingImage.image = UIImage(named:"regular_4")
        } else if (landmark.rating == 4.5) {
            ratingImage.image = UIImage(named:"regular_4_half")
        } else if (landmark.rating == 5) {
            ratingImage.image = UIImage(named:"regular_5")
        }
    }
    
    
    func createAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("OK")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
