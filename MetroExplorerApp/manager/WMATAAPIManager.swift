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
    func stationsNotFound(reason: WMATAAPIManager.FailureReason)
}

class WMATAAPIManager {
    
    enum FailureReason: String {
        case noResponse = "No response received" //allow the user to try again
        case non200Response = "Bad response" //give up
        case noData = "No data recieved" //give up
        case badData = "Bad data" //give up
    }
    
    var delegate: FetchStationsDelegate?
    
    func fetchStations() {
        if var urlComponents = URLComponents(string: "https://api.wmata.com/Rail.svc/json/jStations") {
            
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: "***")
            ]//set the parameters of url
            
            if let url = urlComponents.url {
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"//set request method
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    //PUT CODE HERE TO RUN UPON COMPLETION
                    
                    guard let response = response as? HTTPURLResponse else {
                        self.delegate?.stationsNotFound(reason: .noResponse)
                        
                        return
                    }
                    
                    guard response.statusCode == 200 else {
                        self.delegate?.stationsNotFound(reason: .non200Response)
                        
                        return
                    }
                    
                    //HERE - response is NOT nil and IS 200
                    
                    guard let data = data else {
                        
                        self.delegate?.stationsNotFound(reason: .noData)
                        
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
                            
                            var lineCode2 : String = ""
                            
                            lineCode2 = station.LineCode2 ?? ""//handling situations where there may be no LineCode2
                            
                            var lineCode3 : String = ""
                            
                            lineCode3 = station.LineCode3 ?? ""//handling situations where there may be no LineCode3
                            
                            let station = Station(name: station.Name, address: address, lineCode1: station.LineCode1, lineCode2: lineCode2, lineCode3: lineCode3, lat: station.Lat, lon: station.Lon)
                            
                            stations.append(station)//append station to list
                        }
                        
                        //now we can see the list of stations
                        print(stations)
                        
                        self.delegate?.stationsFound(stations)
                        
                    } catch let error {
                        //if we get here, need to set a breakpoint and inspect the error to see where there is a mismatch between JSON and our Codable model structs
                        print(error.localizedDescription)
                        
                        self.delegate?.stationsNotFound(reason: .badData)
                    }
                }
                
                print("execute request")
                task.resume()
            }
        }
    }
}
