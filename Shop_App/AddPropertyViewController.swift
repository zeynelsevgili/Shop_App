//
//  AddViewController.swift
//  Shop_App
//
//  Created by Demo on 27.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit
import ProgressHUD
import ImagePicker


class AddPropertyViewController: UIViewController, ImagePickerDelegate {

    

    var user: FUser? // neden optional???
    var property: Property?
    var propertyImages: [UIImage] = []
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var referenceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var bathroomTextField: UITextField!
    @IBOutlet weak var propertySizeTextField: UITextField!
    @IBOutlet weak var parkingTextField: UITextField!
    @IBOutlet weak var balconySizeTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var buildYearTextField: UITextField!
    @IBOutlet weak var advertisementTextField: UITextField!
    @IBOutlet weak var availableFromTextField: UITextField!
    @IBOutlet weak var propertyTypeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    // switch outlets
    @IBOutlet weak var titleDeedsSwitch: UISwitch!
    @IBOutlet weak var centralHeatingSwitch: UISwitch!
    @IBOutlet weak var airConditionerSwitch: UISwitch!
    @IBOutlet weak var solarWaterSwitch: UISwitch!
    @IBOutlet weak var furnishedSwitch: UISwitch!
    
    var titleDeedsSwitchValue = false
    var centralHeatingSwitchValue = false
    var airConditionerSwitchValue = false
    var solarWaterSwitchValue = false
    var furnishedSwitchValue = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // bu satır olmadan scroll view çalışmıyor!
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: topView.frame.size.height)

    }

    // Switches Actions
    @IBAction func titleDeedsChanged(_ sender: Any) {
        titleDeedsSwitchValue = !titleDeedsSwitchValue
    }
    
    @IBAction func centralHeatingChanged(_ sender: Any) {
        centralHeatingSwitchValue = !centralHeatingSwitchValue
    }
    
    @IBAction func airConditionerChanged(_ sender: Any) {
        airConditionerSwitchValue = !airConditionerSwitchValue
    }
    @IBAction func solarWaterChanged(_ sender: Any) {
        solarWaterSwitchValue = !solarWaterSwitchValue
    }
    
    @IBAction func furnishedChanged(_ sender: Any) {
        furnishedSwitchValue = !furnishedSwitchValue
    }

    
    // Camera and Save Button Actions
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = kMAXIMAGENUMBER
        
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        
        user = FUser.currentUser()!
        
        
        // normal user ise 1 property ekleyebiliyor ajans ise limit yok
        if !user!.isAgent {
            print("ajans olduğunu teyit için")
             save()
            print("ajanslar için değil")
            // check if user can post
        } else {
           print("Ajanslar için")
           save()
        }
        
    }
    
    
    // Loaction Actions
    @IBAction func mapPinPressed(_ sender: Any) {
    }
    
    @IBAction func currentLocationPressed(_ sender: Any) {
    }
    
    
    // ImagePickerDelegate Conform Methods
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        print("wrapper")
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
     
        print("done")
        propertyImages = images
        print("number of chosen image is \(propertyImages.count)")
        
        self.dismiss(animated: true, completion: nil)

    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)

    }
    
    // Helper Functions
    
    func save() {

       print("save başı")
        if titleTextField.text != "" && referenceTextField.text != "" && propertyTypeTextField.text != "" && priceTextField.text != "" {
            
            // create new property
            var newProperty = Property()
            
            if property != nil {
                newProperty = property!
            }
            
            newProperty.referenceCode = referenceTextField.text!
            newProperty.ownerId = user!.objectID
            newProperty.title = titleTextField.text!
            newProperty.advertiseType = advertisementTextField.text!
            newProperty.price = Int(priceTextField.text!)!
            newProperty.propertyType = propertyTypeTextField.text!

            
            
            if balconySizeTextField.text != "" {
                newProperty.balconySize = Double(balconySizeTextField.text!)!
            }
            if bathroomTextField.text != "" {
                newProperty.numOfBathRooms = Int(bathroomTextField.text!)!
            }
            if roomTextField.text != "" {
                newProperty.numOfRooms = Int(balconySizeTextField.text!)!
            }
            if propertySizeTextField.text != "" {
                newProperty.size = Double(propertySizeTextField.text!)!
            }
            if parkingTextField.text != "" {
                newProperty.parking = Int(parkingTextField.text!)!
            }
            if floorTextField.text != "" {
                newProperty.floor = Int(floorTextField.text!)!
            }
            if adressTextField.text != "" {
                newProperty.adress = adressTextField.text!
            }
            if cityTextField.text != "" {
                newProperty.city = cityTextField.text!
            }
            if countryTextField.text != "" {
                newProperty.country = countryTextField.text!
            }
            if descriptionTextView.text != "" && descriptionTextView.text != "Açıklama"{
                newProperty.propertyDesc = descriptionTextView.text!
            }
            if availableFromTextField.text != "" {
                newProperty.availableFrom = availableFromTextField.text!
            }
            if buildYearTextField.text != "" {
                newProperty.buildYear = buildYearTextField.text!
            }

            newProperty.titleDeeds = titleDeedsSwitchValue
            newProperty.centralHeating = centralHeatingSwitchValue
            newProperty.airConditioner = airConditionerSwitchValue
            newProperty.isFurnished = furnishedSwitchValue
            newProperty.solarWaterSystem = solarWaterSwitchValue
            newProperty.saveProperty()
            
            // eğer resim yoksa resim olmadan else kısmıyla kaydedecek newProperty objesini.
            // if kısmında ise resimler ile birlikte kaydedecek.
            if propertyImages.count != 0 {
                
                // linkString gelir ve bunları imageLinks global değişkenine atıyoruz.
                // sonrasında save ediyoruz.
                uploadImages(images: propertyImages, userID: user!.objectID, referenceNumber: newProperty.referenceCode!, withBlock: { (linkString) in
                    
                    newProperty.imageLinks = linkString
                    newProperty.saveProperty()
                    ProgressHUD.showSuccess("resimler upload edildi.")
                    self.dismissView()
                })
                
            } else {
                newProperty.saveProperty()
                ProgressHUD.showSuccess("Başarıyla kaydedildi(Image?)")
                dismissView()
            }
            ProgressHUD.showSuccess("Başarıyla kaydedildi.")
        } else {
            
            ProgressHUD.showError("İstenilen alanları doldurun lütfen. Ağzınızı kırarım yoksa")
            
            
        }
    }
    
    func dismissView() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
}
