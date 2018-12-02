//
//  YelpAPIManager.swift
//  MetroExplorerApp
//
//  Created by Joshua on 11/25/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

protocol FetchLandmarksDelegate {
    func landmarksFound(_ landmarks: [Landmark])
    func landmarksNotFound()
}

class YelpAPIManager {
    
    var delegate: FetchLandmarksDelegate?
    
    func fetchStations() {
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: "landmarks"),
            URLQueryItem(name: "latitude", value: "38.876588"),
            URLQueryItem(name: "longitude", value: "-77.005086"),
            URLQueryItem(name: "radius", value: "2000")
        ]
        
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Bearer ***", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //PUT CODE HERE TO RUN UPON COMPLETION
            print("request complete")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("response is nil or not 200")
                
                self.delegate?.landmarksNotFound()
                
                return
            }
            
            //HERE - response is NOT nil and IS 200
            
            guard let data = data else {
                print("data is nil")
                
                self.delegate?.landmarksNotFound()
                
                return
            }
            
            //HERE - data is NOT nil
            
            let decoder = JSONDecoder()
            
            do {
                let yelpResponse = try decoder.decode(YelpResponse.self, from: data)
                
                //HERE - decoding was successful
                
                var landmarks = [Landmark]()
                
                for landmark in yelpResponse.businesses {
                    let name = landmark.name
                    let rating = landmark.rating
                    
                    var image_url : String = " "
                    
                    if (landmark.imageUrl != "") {
                        image_url = landmark.imageUrl!
                    }
                    
                    var address : String = " "
                    
                    if (landmark.location.address1 != "") {
                        address = "\(landmark.location.address1), \(landmark.location.city)"
                    } else {
                        address = "\(landmark.location.city)"
                    }
                    
                    let landmark = Landmark(name: name, address: address, image_url: image_url, rating: rating)
                    
                    landmarks.append(landmark)
                }
                
                //now what do we do with the gyms????
                print(landmarks)
                
                self.delegate?.landmarksFound(landmarks)
                
                
            } catch let error {
                //if we get here, need to set a breakpoint and inspect the error to see where there is a mismatch between JSON and our Codable model structs
                print("codable failed - bad data format")
                print(error.localizedDescription)
                
                self.delegate?.landmarksNotFound()
            }
        }
        
        print("execute request")
        task.resume()
    }
}
