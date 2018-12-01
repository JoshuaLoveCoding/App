//
//  StationsTableViewCell.swift
//  MetroExplorerApp
//
//  Created by Joshua on 11/30/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import UIKit

class StationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationAddressLabel: UILabel!
    @IBOutlet weak var lineCodeImage1: UIImageView!
    @IBOutlet weak var lineCodeImage2: UIImageView!
    @IBOutlet weak var lineCodeImage3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
