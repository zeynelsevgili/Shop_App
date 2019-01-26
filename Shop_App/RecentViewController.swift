//
//  RecentViewController.swift
//  Shop_App
//
//  Created by Demo on 25.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
      
     
        
    }

}
