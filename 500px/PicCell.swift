//
//  PicCell.swift
//  500px
//
//  Created by Finn Gaida on 08.10.15.
//  Copyright © 2015 Finn Gaida. All rights reserved.
//

import UIKit

class PicCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func setImage(img: UIImage, title: String) {
        self.imageView.image = img
        self.label.text = title
    }
    
}
