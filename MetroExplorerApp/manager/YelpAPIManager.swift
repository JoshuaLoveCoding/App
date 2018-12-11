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
    func landmarksNotFound(reason: YelpAPIManager.FailureReason)
}

class YelpAPIManager {
    
    enum FailureReason: String {
        case noResponse = "No response received" //allow the user to try again
        case non200Response = "Bad response" //give up
        case noData = "No data recieved" //give up
        case badData = "Bad data" //give up
    }
    
    var delegate: FetchLandmarksDelegate?
    
    func fetchLandmarks(lat: Double, lon: Double) {
        if var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search") {
            
            urlComponents.queryItems = [
                URLQueryItem(name: "term", value: "landmarks"),
                URLQueryItem(name: "latitude", value: "\(lat)"),
                URLQueryItem(name: "longitude", value: "\(lon)"),
                URLQueryItem(name: "radius", value: "2000")
            ]
            
            if let url = urlComponents.url {
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                
                request.addValue("Bearer ***", forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    //PUT CODE HERE TO RUN UPON COMPLETION
                    
                    guard let response = response as? HTTPURLResponse else {
                        
                        self.delegate?.landmarksNotFound(reason: .noResponse)
                        
                        return
                    }
                    
                    guard response.statusCode == 200 else {
                        self.delegate?.landmarksNotFound(reason: .non200Response)
                        
                        return
                    }
                    //HERE - response is NOT nil and IS 200
                    
                    guard let data = data else {
                        
                        self.delegate?.landmarksNotFound(reason: .noData)
                        
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
                            let latitude = landmark.coordinates.latitude
                            let longitude = landmark.coordinates.longitude
                            
                            var image_url : String = ""
                            
                            image_url = landmark.imageUrl ?? ""
                            
                            var address : String = ""
                            
                            if landmark.location.address1 != nil && landmark.location.address1 != "" {
                                address = "\(landmark.location.address1 ?? ""), \(landmark.location.city)"
                            } else {
                                address = "\(landmark.location.city)"
                            }
                            
                            let landmark = Landmark(name: name, address: address, image_url: image_url, rating: rating, latitude: latitude, longitude: longitude)
                            
                            landmarks.append(landmark)
                        }
                        
                        //now what do we do with the landmarks????
                        print(landmarks)
                        
                        self.delegate?.landmarksFound(landmarks)
                        
                        
                    } catch let error {
                        //if we get here, need to set a breakpoint and inspect the error to see where there is a mismatch between JSON and our Codable model structs
                        print(error.localizedDescription)
                        
                        self.delegate?.landmarksNotFound(reason: .badData)
                    }
                }
                
                print("execute request")
                task.resume()
            }
        }
    }
}
