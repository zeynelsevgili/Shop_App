//
//  FUser.swift
//  Shop_App
//
//  Created by Demo on 21.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FUser {
    
    let objectID: String
    var pushID: String? // optional neden oluyor takip et
    let createdAt: Date
    var updateAt: Date
    var coins: Int
    var companyName: String
    var firstName: String
    var lastName: String
    var fullName: String
    var avatar: String
    var phoneNumber: String
    var additionalPhone: String
    var isAgent: Bool
    var favouriteProperties: [String]
    
    // yukarıdakilerin hepsi initialize edilmezse hata veriyor.
    // optional olanlar initialize edilmeyebilir!
    init(_objectID: String, _pushID: String?, _createdID: Date, _updatedID: Date, _firstName: String, _lastName: String, _avatar: String = "", _phoneNumber: String = "") {
        
        objectID = _objectID
        pushID = _pushID
        createdAt = _createdID
        updateAt = _updatedID
        firstName = _firstName
        lastName = _lastName
        avatar = _avatar
        phoneNumber = _phoneNumber
        coins = 10
        fullName = firstName + " " + lastName
        
        // Bu dördüne dikkat et neden bu şekilde kullanılmış
        isAgent = false
        companyName = ""
        favouriteProperties = []
        additionalPhone = ""
  
        
    }
    
    
    // NSDictionary formatındaki bilgi, Firebase den alındıktan sonraki initializerdır bu...
    // NSDictionary türünde firebase den gelen bilgi her bir instance değişkenine ayrı ayrı atanıyor.
    
    init(_dictionary: NSDictionary) {
        
        objectID = _dictionary[kOBJECTID] as! String
        pushID = _dictionary[kPUSHID] as? String
        
        // aşağıdaki constant nasıl kulllanılacak çok önemli
        if let created = _dictionary[kCREATEDAT] {
            
            createdAt = dateFormatter().date(from: created as! String)!
            
        }else {
            
            createdAt = Date()
            
            
        }
        
        if let updated = _dictionary[kUPDATEDAT] {
            updateAt = dateFormatter().date(from: updated as! String)!
        } else {
            updateAt = Date()
        }
        
        if let fName = _dictionary[kFIRSTNAME] {
            firstName = fName as! String
        } else {
            firstName = ""
        }
        
        if let lName = _dictionary[kLASTNAME] {
            lastName = lName as! String
        } else {
            lastName = ""
        }
        
        if let avtr = _dictionary[kFIRSTNAME] {
            avatar = avtr as! String
        } else {
            avatar = ""
        }
        
        if let cName = _dictionary[kCOMPANY] {
            companyName = cName as! String
        } else {
            companyName = ""
        }
        if let dcoin = _dictionary[kCOINS] {
            coins = dcoin as! Int
        } else {
            coins = 0
        }
        if let agent = _dictionary[kISAGENT] {
            isAgent = agent as! Bool
        } else {
            isAgent = false
        }
        if let pNumber = _dictionary[kPHONE] {
            phoneNumber = pNumber as! String
        } else {
            phoneNumber = ""
        }
        if let addPhone = _dictionary[kADDPHONE] {
            additionalPhone = addPhone as! String
        } else {
            additionalPhone = ""
        }
        if let favProp = _dictionary[kFAVORIT] {
            favouriteProperties = favProp as! [String]
        } else {
            favouriteProperties = []
        }
        
        fullName = firstName + " " + lastName
        if let fuName = _dictionary[kFULLNAME] {
             fullName = fuName as! String
        } else {
            fullName = ""
        }
        
        
    }
    
    // "Class func" kullanırken sınıfın bir instance ini oluşturmaya gerek kalmıyor
    // Mesela geleneksel kullanım şöyledir.   let zeynel = FUser() --- Devamında zeynel.anyFunction()
    // fakat class ile tanımlanmış fonksiyon kullanımı ise şöyledir ---  FUser.zeynel.anyFunction()
    
    
    // doğrulama kodu talep edildikten sonra bu kod icra edilecek. yani verification kod textfield kısmına girmiş olacak
    class func registerUserWithPhone(phoneNumber: String, verificationCode: String, completion: @escaping (_ error: Error?, _ shouldLogin: Bool) -> Void) {
        
        // buraya verification kod nasıl gelecek???
        // Telefon girildikten sonra verification kod google dan geliş kodu nerede???
        let verificationID = UserDefaults.standard.value(forKey: kVERIFICATIONCODE)
        
        // burada firebase e bir kod gönderiyoruz. ve bu kod üzerinden kayıt yapacağız herhalde...
        let credential = PhoneAuthProvider.provider().credential(withVerificationID:verificationID as! String, verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (firUser, error) in
            
            
            if(error != nil) {
                completion(error!, false)
                return
            }
            
            //check if user is logged in else register.
            fetchUserWith(userID:(firUser!.user.uid), completion: { (user) in
                
                if user != nil && user!.firstName != "" {
                    
                    saveUserLocally(user: user!)
                    // bu fonksiyonun completionu true ise mainView kısmına dönülecek
                    // çünkü zaten kişi kayıtlı
                    completion(error, true)

                }else {
                    
                    // firstname ve lastname will be emty
                    // because we will continue registeration with additional viewcontroller
                    let fUser = FUser(_objectID: firUser!.user.uid, _pushID: "", _createdID: Date(), _updatedID: Date(), _firstName: "", _lastName: "", _phoneNumber: firUser!.user.phoneNumber!)
                    
                    saveUserLocally(user: fUser)
                    saveUserInBackground(fuser: fUser)
                    
                    // bu fonksiyonun completionu false ise finishRegisterView kısmına dönülecek
                    // kişi kayıtlı değil de ondan...
                    completion(error, false)

                }
            })
            
            
        }
        
        
    }
    
    
    // Aşağıdaki fonksiyonlar FUser dışına da hitap ediyor.
    // Dışarıdan çağırmanın rahatlığı için kullanılıyor.(FUser.registerWithEmail...)
    // current user id
    class func currentID() -> String{
        
        
       return Auth.auth().currentUser!.uid
    }
    
    // current user information. bir NSDictionary dönmesi lazım
    class func currentUser() -> FUser? {
      
        if Auth.auth().currentUser != nil {
            
            // cihazda user default kısmında bir şey var mı? Varsa constructor a userdefault da olan dictionary i gönder.
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                
                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
    class func regiterUserWithEmail(email: String, firstname: String, lastname: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
            
            // it does not execute the rest of code
            if(error != nil){
                completion(error)
                return
            }
            
            // Burada kayıt yapılırken, kaydı yapılan kişiyle ilgili constructor yapılandırılıyor.
            // sonrasında bu obje localde kayıt için kullanılacak.
            let fUser = FUser(_objectID: (firUser!.user.uid), _pushID: "", _createdID: Date(), _updatedID: Date(), _firstName: firstname, _lastName: lastname)
            
            saveUserLocally(user: fUser)
            saveUserInBackground(fuser: fUser)
            
            completion(error)
            
        }
        
    } // end of func
 
}// end of class



// helper functions(Bu fonksiyonlar yukarıdaki class fonksiyonlarına hizmet ediyor.
// Bundan ötürü "class" kelimesi başta kullanılmadı.)
func fetchUserWith(userID: String, completion: @escaping (_ user: FUser?) -> Void) {
    
    // .value bütün herşeyi döner
    firebaseDatabase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in
        
        if snapshot.exists() {
            
            // bir array aldığımız için allValues diyoruz
            // firstObject kısmı anlaşılamadı???
            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject as! NSDictionary
            
            let user = FUser(_dictionary: userDictionary)
            
            completion(user)
            
        }else {
            completion(nil)
        }
        
    }
    
    
}

// hem local hem background(firebase) kısmına
// verileri kaydetmek için Dictionary formatında veri göndermemiz gerekir.
// bundan ötürü ortak bir fonksiyon(userDictionaryFrom --> NSDictionary oluşturuldu)
func saveUserInBackground(fuser: FUser) {
    
    let ref = firebaseDatabase.child(kUSER).child(fuser.objectID)
    
    // database e oluşturduğumuz fonksiyondan gelen bir dictionary gönderiyoruz.
    ref.setValue(userDictionaryFrom(user: fuser))
}

func saveUserLocally(user: FUser) {
    
    UserDefaults.standard.set(userDictionaryFrom(user: user), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
    
}

func userDictionaryFrom(user: FUser) -> NSDictionary{
    
    
    let createAt = dateFormatter().string(from: user.createdAt)
    let updateAt = dateFormatter().string(from: user.updateAt)
    
    
    //şu tarzda bir değer dönüyoruz ----> return NSDictionary(objects: [] , forKeys: [])
    
    return NSDictionary(objects: [user.objectID, user.pushID!, createAt, updateAt, user.firstName, user.lastName, user.avatar, user.phoneNumber, user.coins, user.fullName, user.isAgent, user.companyName, user.favouriteProperties, user.additionalPhone], forKeys: [kOBJECTID as NSCopying, kPUSHID as NSCopying,  kCREATEDAT as NSCopying, kUPDATEDAT as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kAVATAR as NSCopying, kPHONE as NSCopying, kCOINS as NSCopying, kFULLNAME as NSCopying, kISAGENT as NSCopying, kCOMPANY as NSCopying, kFAVORIT as NSCopying, kADDPHONE as NSCopying])

}

// 2. Anlaşılmadı.
func updateCurrentUser(withValues: [String: Any], withBlock: @escaping (_ success: Bool)->Void) {
    
    if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
        
        let currentUser = FUser.currentUser()!
        
        // NSMutableDictionary: An object representing a dynamic collection of key-value pairs
        // burafa bir FUser objesi koyacağız çıkış olarak key-value pairi elde edeceğiz.
        let userObject = userDictionaryFrom(user: currentUser).mutableCopy() as! NSMutableDictionary
        // burada mevcut key-value pairli OBJE'mize, bir key-value stringi daha ekleyeceğiz
        userObject.setValuesForKeys(withValues)
        let ref = firebaseDatabase.child(kUSER).child(currentUser.objectID)
        
        ref.updateChildValues(withValues, withCompletionBlock: { (error, ref) in
            
            if error != nil {
                withBlock(false)
                return
            }
            
            UserDefaults.standard.setValue(userObject, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            withBlock(true)
            
        })
    }
    
    
}













