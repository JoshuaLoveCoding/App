//
//  FavoritesTableViewCell.swift
//  MetroExplorerApp
//
//  Created by Joshua on 12/5/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit
class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteNameLabel: UILabel!
    @IBOutlet weak var favoriteAddressLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
