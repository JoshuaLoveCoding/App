//
//  Extensions.swift
//  MetroExplorerApp
//
//  Created by Joshua on 12/2/18.
//  Copyright © 2018 Joshua. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    //asynchronous loading url to show image
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
