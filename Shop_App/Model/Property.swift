//
//  Property.swift
//  Shop_App
//
//  Created by Demo on 25.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import Foundation

@objcMembers
class Property: NSObject {
    
    var objectID: String?
    var referenceCode: String?
    var ownerID: String?
    var numOfRooms: Int = 0;
    var numOfBathRooms: Int = 0
    var size: Double = 0.0
    var balconySize: Double = 0.0
    var parking: Int = 0
    var floor: Int = 0
    var adress: String?
    var city: String?
    var country: String?
    var propertyDesc: String?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var advertiseType: String?
    var availableFrom: String?
    var imageLinks: String?
    var buildYear: String?
    var price: Int = 0
    var propertyType: String?
    var titleDeeds: Bool = false
    var centralHeating: Bool = false
    var solarWaterSystem: Bool = false
    var airConditioner: Bool = false
    var storeRoom: Bool = false
    var isFurnished: Bool = false
    var isSold: Bool = false
    var inTopUntil: Date?
    
    //MARK: Save Functions
    
    // burası çok önemli altın değerinde viewController da oluşturduğumuz array nasıl kayıt ediyor???
    // save property diyor. Parametre yok nasıl save edecek???
    // aşağıdaki tablolarda "property: Property" diye parametre almış. Bu da acaba ona benzer mi?
    // denemesi yapılırken mutlaka dene aynı kapıya çıkıyorsa sorun yok. iki farklı kullanım vardır.
    func saveProperty() {
        
        // Property class ı ile ilgili bir tablo oluşturur backendless da.
        let dataStore = backendless!.data.of(Property.ofClass())
        dataStore!.save(self)
        
    }
    
    func saveProperty(completion: @escaping (_ value: String) -> Void) {
        
        let dataStore = backendless!.data.of(Property.ofClass())
        dataStore!.save(self, response: { (result) in
            
            completion("kaydetme tamamlandı")
            
            
            // Error veya Fault'u optional yapmamızın nedeni,
            // hatanın değer alabilir veya almayabilir olmasıdır.
        }) { (fault: Fault?) in
            completion(fault!.message)
        }
    }
    
    //MARK: Delete Functions
    
    func deleteProperty(property: Property) {
        
        let dataStore = backendless!.data.of(property.ofClass())
        dataStore!.remove(property)
        
    }
    
    func deleteProperty(property: Property, completion: @escaping (_ value: String) -> Void) {
        
        let dataStore = backendless!.data.of(property.ofClass())
        dataStore!.remove(self, response: { (result) in
            
            completion("remove tamamlandı")
            
            
        }) { (faults: Fault?) in
            
            completion(faults!.message)
            
        }
        
    }
    
    class func fetchRecentProperties(limit: Int, completion: @escaping (_ properties: [Property?]) -> Void) {
        
        let queryBuilder = DataQueryBuilder()
        queryBuilder!.setSortBy(["inTopUntil DESC"])
        queryBuilder!.setPageSize(Int32(limit))
        queryBuilder!.setOffset(0)
        
        
        let dataStore = backendless!.data.of(Property().ofClass())
        
        dataStore!.find(queryBuilder, response: { (backendlessResponse) in
        
            completion(backendlessResponse as! [Property])
        }) { (fault: Fault?) in
            
            print("limitli search yapılırken bir hata meydana geldi.\(fault!.message)")
            completion([])
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
}


