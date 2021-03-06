//
//  AppDelegate.swift
//  Shop_App
//
//  Created by Demo on 20.01.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let APP_ID = "0074EF4F-F599-F4D7-FFB0-C0C2237F7F00"
    let API_KEY = "13FBE098-8730-0DF0-FFB2-49D7BF982900"
//        let APP_ID = "84BFAE23-52D5-0B42-FF57-FC79DBA15200"
//        let API_KEY = "E6C7A3D0-42B5-1DDE-FF57-AF5EB1887E00"
    // aşağıdaki olabilir de olmayabilir
    //let SERVER_URL = "https://api.backendless.com"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        backendless!.initApp(APP_ID, apiKey: API_KEY)
        //backendless!.hostURL = SERVER_URL()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

