//
//  AppDelegate.swift
//  ToDoL
//
//  Created by mac on 1/3/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    
        
        do {
            _ = try Realm()
            
        }catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }

}

