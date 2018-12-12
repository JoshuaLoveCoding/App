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
    
    let favoritesKey = "favorites"//set key to keep and find data
    
    func saveFavorite(landmark: Landmark) {
        let userDefaults = UserDefaults.standard//UserDefaults to persist users’ data
        
        var favorites = fetchFavorites()
        var have : Bool = false
        var int : Int = 0
        //to check if the current item is in the favorites list
        for ele in favorites {
            if ele.address == landmark.address {
                have = true
                break
            }
            int = int + 1//keep the index of the item
        }
        if have == false {
            favorites.append(landmark)//the new item is added to the list
        } else {
            favorites.remove(at: int)//the existing item is removed from the list
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

