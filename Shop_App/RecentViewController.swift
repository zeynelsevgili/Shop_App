//
//  RecentViewController.swift
//  Shop_App
//
//  Created by Demo on 25.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit
import ProgressHUD

class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PropertyCollectionViewCellDelegate {
    
    var numOfPropertiesTextfield: UITextField?
    var properties: [Property] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // load properties
        
        loadProperties(limitItems: kRECENTPROPERTYLIMIT)
    }
    
    override func viewWillLayoutSubviews() {
    
        collectionView.collectionViewLayout.invalidateLayout()

    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    //Mark: DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // dizi count u yazılmaz ise hata veriyor.(Index out of range)
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "propertyCell", for: indexPath) as! PropertyCollectionViewCell
        cell.delegate = self
        cell.generateCell(property: properties[indexPath.row])
        return cell
        
    }
    
    
    
    //Mark: Delegate
    
    
    // kullanıcı bir cell'e bastığında ne olacak?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // view source
    }
    
    // size for cell. CGSize is return type
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        // bu satır çok önemli bu girildikten sonra bütün kaymalar gitti.
        // cell in width ve orjinal height kısmı giriliyor.
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(254))
        
    }
    
    
    //Mark: Load Properties
    
    func loadProperties(limitItems: Int) {
        
        Property.fetchRecentProperties(limit: limitItems) { (recentProperties) in
            
            if recentProperties.count != 0 {
                
                // properties dizi şeklinde tanımlandığı için [Property] kullanımı gerekiyor
                self.properties = recentProperties as! [Property]
                self.collectionView.reloadData()
                
                
            }
            
            
        }
        
    }
    
    @IBAction func filterBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Güncelle", message: "Kaç Sonuç Görmek istiyorsanız rakamla girin", preferredStyle: .alert)
        
        alertController.addTextField { (numOfProperties) in
        
            numOfProperties.placeholder = "Görmek istediğiniz miktar"
            numOfProperties.borderStyle = .roundedRect
            numOfProperties.keyboardType = .numberPad
            
            self.numOfPropertiesTextfield = numOfProperties
            
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { (action) in
            
        }
        
        let updateAction = UIAlertAction(title: "Güncelle", style: .default) { (action) in
            
            if self.numOfPropertiesTextfield?.text != "" && self.numOfPropertiesTextfield!.text != "0" {
                
                ProgressHUD.show("Güncelliyor...")
                self.loadProperties(limitItems: Int(self.numOfPropertiesTextfield!.text!)!)
                ProgressHUD.showSuccess("Güncelledi")

                
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    //Mark: PropertyCollectionViewCellDelegate
    
    // cell bize star butonunun tıklandığını haber veriyor.(Delegate yardımıyla)
    // tıklandığında vievController ın ne yapacağını bu fonksiyon icra edecek.
    
    // 3. Tam anlaşılmadı. Business logic kısmı???
    func didClickStarButton(property: Property) {
        
        // Optional değer dönüldüğü için Unwrap yaptık.
        if let user = FUser.currentUser() {
            // check if the property is in favourite
            if user.favouriteProperties.contains(property.ownerId!){
                // remove from favourite list
                let index = user.favouriteProperties.index(of: property.ownerId!)
                user.favouriteProperties.remove(at: index!)
                
                updateCurrentUser(withValues: [kFAVORIT : user.favouriteProperties], withBlock: { (success) in
                    if !success {
                        print("error occured during removing favourite")
                    } else {
                        
                        self.collectionView.reloadData()
                        ProgressHUD.showSuccess("Listeden başarılı bir şekilde silindi.")
                    }
             })
            } else {
                // add to favourite list
                user.favouriteProperties.append(property.ownerId!)
                updateCurrentUser(withValues: [kFAVORIT : user.favouriteProperties], withBlock: { (success) in
                    if !success {
                        print("error occured during adding favourite")
                    } else {
                        self.collectionView.reloadData()
                        ProgressHUD.showSuccess("Listeye başarılı bir şekilde eklendi.")
                    }
                })
            }
        } else {
            // kayıtlı değildir muhtemelen. show login/register screen

        }
    }
}
