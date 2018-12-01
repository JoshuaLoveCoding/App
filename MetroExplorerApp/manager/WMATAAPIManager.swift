//
//  WMATAAPIManager.swift
//  MetroExplorerApp
//
//  Created by Joshua on 11/25/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

protocol FetchStationsDelegate {
    func stationsFound(_ stations: [Station])
    func stationsNotFound()
}

class WMATAAPIManager {
    
    var delegate: FetchStationsDelegate?
    
    func fetchStations() {
        var urlComponents = URLComponents(string: "https://api.wmata.com/Rail.svc/json/jStations")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "***")
        ]
        
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //PUT CODE HERE TO RUN UPON COMPLETION
            print("request complete")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("response is nil or not 200")
                
                self.delegate?.stationsNotFound()
                
                return
            }
            
            //HERE - response is NOT nil and IS 200
            
            guard let data = data else {
                print("data is nil")
                
                self.delegate?.stationsNotFound()
                
                return
            }
            
            //HERE - data is NOT nil
            
            let decoder = JSONDecoder()
            
            do {
                let wmataResponse = try decoder.decode(WMATAResponse.self, from: data)
                
                //HERE - decoding was successful
                
                var stations = [Station]()
                
                for station in wmataResponse.Stations {
                    let street = station.Address.Street
                    let city = station.Address.City
                    let state = station.Address.State
                    
                    let address : String? = "\(street), \(city), \(state)"
                    
                    var lineCode2 : String = " "
                    
                    if (station.LineCode2 != nil) {
                        lineCode2 = station.LineCode2!
                    }
                    
                    var lineCode3 : String = " "
                    
                    if (station.LineCode3 != nil) {
                        lineCode3 = station.LineCode3!
                    }
                    
                    let station = Station(name: station.Name, address: address, lineCode1: station.LineCode1, lineCode2: lineCode2, lineCode3: lineCode3, lat: station.Lat, lon: station.Lon)
                    
                    stations.append(station)
                }
                
                //now what do we do with the gyms????
                print(stations)
                
                self.delegate?.stationsFound(stations)
                
                
            } catch let error {
                //if we get here, need to set a breakpoint and inspect the error to see where there is a mismatch between JSON and our Codable model structs
                print("codable failed - bad data format")
                print(error.localizedDescription)
                
                self.delegate?.stationsNotFound()
            }
        }
        
        print("execute request")
        task.resume()
    }
}
