//
//  Landmark.swift
//  MetroExplorerApp
//
//  Created by Joshua on 12/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

struct Landmark: Codable {
    let name: String
    let address: String?
    let image_url : String
    let rating : Double
    let latitude: Double
    let longitude: Double
}
