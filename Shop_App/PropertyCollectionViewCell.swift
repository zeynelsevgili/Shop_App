//
//  PropertyCollectionViewCell.swift
//  Shop_App
//
//  Created by Demo on 25.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

class PropertyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var bathRoomLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var soldImageView: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    
    
    @IBAction func likeBtnPressed(_ sender: Any) {
    }
    
    
}
