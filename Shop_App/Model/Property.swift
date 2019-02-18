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
    // hepsi optional veya değer atanmış olduğu için initializer'a gerek duyulmuyor.
    
    var referenceCode: String?
    var title: String?
    var ownerId: String?
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
    //var storeRoom: Bool = false
    var isFurnished: Bool = false
    var isSold: Bool = false
    var inTopUntil: Date?

    //MARK: Save Functions
    func saveProperty() {
        print("backendless başlangıcı")
        let dataStore = backendless!.data.of(Property.ofClass())
        print("backendless instance oluşturuluduktan sonra")

        dataStore?.save(self, response: { (response) in
            
            if response != nil {
                
                print("success")
            }
            
            
        }, error: { (fault: Fault?) in
            
            print("hata yapıldı:\(fault.debugDescription)")
        })

    }

    
    func saveProperty(completion: @escaping (_ value: String) -> Void) {
        
        let dataStore = backendless!.data.of(Property().ofClass())
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
    
    // burada parametre olarak Property alıyor. Dönüş String oluyor.
    // Muhtemelen silindi diye ekrana yansıtacak.
    func deleteProperty(property: Property, completion: @escaping (_ value: String) -> Void) {
        
        let dataStore = backendless!.data.of(property.ofClass())
        dataStore!.remove(self, response: { (result) in
            
            completion("remove tamamlandı")
            
            
        }) { (faults: Fault?) in
            
            completion(faults!.message)
            
        }
        
    }
    
    
    // inTopUntil database kısmına yerleştirilmezse fetch edilmeyebilir dikkat et
    class func fetchRecentProperties(limit: Int, completion: @escaping (_ properties: [Property?]) -> Void) {
        
        let queryBuilder = DataQueryBuilder()
        queryBuilder!.setSortBy(["inTopUntil DESC"])
        queryBuilder!.setPageSize(Int32(limit))
        queryBuilder!.setOffset(0)
        
        
        let dataStore = backendless!.data.of(Property().ofClass())
        
        dataStore!.find(queryBuilder, response: { (backendlessResponse) in
        
            completion(backendlessResponse as! [Property])
        }) { (fault: Fault?) in
            
            print("limitli search yapılırken bir hata meydana geldi.\(fault!.debugDescription)")
            completion([])
            
        }
        
        
    }
    
    class func fetchAllProperties(completion: @escaping (_ properties: [Property]) -> Void) {
        
        let dataStore = backendless!.data.of(Property().ofClass())
        
        dataStore!.find({ (allProperties) in
            
            completion(allProperties as! [Property])
            
            
        }) { (fault: Fault?) in
            
            print("Bütün hepsini getirirken hata meydana geldi\(fault!.message)")
            completion([])
            
            
        }
    }
    
    class func fetchPropertiesWithWhereClouse(whereClouse: String, completion: @escaping (_ properties: [Property]) -> Void) {
        
        let queryBuilder = DataQueryBuilder()
        queryBuilder!.setWhereClause(whereClouse)
        queryBuilder!.setSortBy(["inTopUntil DESC"])
        
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.find(queryBuilder, response: { (backendlessResponse) in
            completion(backendlessResponse as! [Property])
            
        }) { (fault: Fault?) in
            
            print("where tümcesiyle search edilirken hata meydana geldi\(fault!.message)")
            completion([])
        }
        
        
    }
   
}


