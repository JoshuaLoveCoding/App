//
//  LandmarksTableViewCell.swift
//  MetroExplorerApp
//
//  Created by Joshua on 12/1/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class LandmarksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var landmarkNameLabel: UILabel!
    @IBOutlet weak var landmarkAddressLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
