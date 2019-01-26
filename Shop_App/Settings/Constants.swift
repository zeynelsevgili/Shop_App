//
//  Constants.swift
//  Shop_App
//
//  Created by Demo on 20.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Bu constant ile Backendless in bir instance ini oluşturuyoruz. Heryerden ulaşabileceğiz.
var backendless = Backendless.sharedInstance()

// bütün sınıflar tarafından ulaşılabilmesi için public tanımlıyoruz.

// Database
var firebaseDatabase = Database.database().reference()

// FUser
public let kOBJECTID = "objectId"
public let kCREATEDAT = "createdAt"
public let kUSER = "User"
public let kUPDATEDAT = "updatedAt"
public let kCOMPANY = "company"
public let kPHONE = "phone"
public let kADDPHONE = "addPhone"

public let kCOINS = "coins"
public let kPUSHID = "pushId"
public let kFIRSTNAME = "firstname"
public let kLASTNAME = "lastname"
public let kFULLNAME = "fullname"
public let kAVATAR = "avatar"
public let kCURRENTUSER = "currentUser"
public let kISONLINE = "isOnline"
public let kVERIFICATIONCODE = "firebase_verification"
public let kISAGENT = "isAgent"
public let kFAVORIT = "favoritProperties"
