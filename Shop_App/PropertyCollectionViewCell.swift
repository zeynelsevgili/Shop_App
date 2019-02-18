//
//  PropertyCollectionViewCell.swift
//  Shop_App
//
//  Created by Demo on 25.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit


// burada delege protokolu tanımlıyoruz.
// abstract metodları optional olursa metod tanımlama zorunluluğu gerektirmiyor.


@objc protocol PropertyCollectionViewCellDelegate {
    
    @objc optional func didClickStarButton(property: Property)
    @objc optional func didClickMenuButton(property: Property)
    
}


class PropertyCollectionViewCell: UICollectionViewCell {
    
     var delegate: PropertyCollectionViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var bathRoomLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var soldImageView: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var property: Property!
    
    func generateCell(property: Property) {
        
        self.property = property
        
        titleLabel.text = property.title
        roomLabel.text = "\(property.numOfRooms)"
        bathRoomLabel.text = "\(property.numOfBathRooms)"
        parkingLabel.text = "\(property.parking)"
        priceLabel.text = "\(property.price)"
        priceLabel.sizeToFit()

        if property.isSold {
            
            soldImageView.isHidden = false
        } else {
            soldImageView.isHidden = true
        }
        
        if property.imageLinks != "" && property.imageLinks != nil {
            
            // download images
            downloadImages(urls: property.imageLinks!, withBlock: { (images) in
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.ImageView.image = images.first!
                
                
            })
            
        } else {
            self.ImageView.image = UIImage(named: "propertyPlaceholder")
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            
        }
        
        // 1. Burası anlaşılmadı
        if property.inTopUntil != nil && property.inTopUntil! > Date() {
            topImageView.isHidden = false
        } else {
            topImageView.isHidden = true
        }
  
        // 4. Yine bak tam anlaşılmadı.FavouriteProperties database kısmı...
        if self.likeButton != nil {
            
            if FUser.currentUser() != nil && FUser.currentUser()!.favouriteProperties.contains(property.ownerId!) {
                self.likeButton.setImage(UIImage(named: "starFilled"), for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named: "star"), for: .normal)
            }
            
        }
        
        
        
        
    }
    
    // dikkat et birden fazla outlet veya action oluşturulmuşsa başa bela oluyor.
    @IBAction func starBtnPressed(_ sender: Any) {
        print("zeynel")

        delegate!.didClickStarButton!(property: property)

    }

    
    
    
    
    
}
