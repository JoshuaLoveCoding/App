//
//  PersistenceManager.swift
//  MetroExplorerApp
//
//  Created by Joshua on 11/25/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation

class PersistenceManager {
    static let sharedInstance = PersistenceManager()
    
    let favoritesKey = "favorites"
    
    func saveFavorite(landmark: Landmark) {
        let userDefaults = UserDefaults.standard
        
        var favorites = fetchFavorites()
        var have : Bool = false
        var int : Int = 0
        for ele in favorites {
            if (ele.address == landmark.address) {
                have = true
                break
            }
            int = int + 1
        }
        if (have != true) {
            favorites.append(landmark)
        } else {
            favorites.remove(at: int)
        }
        print(favorites)
        let encoder = JSONEncoder()
        let encodedWorkouts = try? encoder.encode(favorites)
        
        userDefaults.set(encodedWorkouts, forKey: favoritesKey)
    }
    
    func fetchFavorites() -> [Landmark] {
        let userDefaults = UserDefaults.standard
        
        if let favoriteData = userDefaults.data(forKey: favoritesKey), let favorites = try? JSONDecoder().decode([Landmark].self, from: favoriteData) {
            //workoutData is non-nil and successfully decoded
            return favorites
        }
        else {
            return [Landmark]()
        }
    }
    
    
}

