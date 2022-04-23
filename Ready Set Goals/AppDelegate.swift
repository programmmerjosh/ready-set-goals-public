//
//  AppDelegate.swift
//  Ready Set Goals
//
//  Created by Joshua Van Niekerk on 19/05/2020.
//  Copyright © 2020 Josh-Dog101. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // locate your Realm File:
//         print(Realm.Configuration.defaultConfiguration.fileURL)
        
            
        // just to catch any errors when initializing Realm
        do {
            _ = try Realm()
        } catch {
            print("Error with Realm: \(error)")
        }
        return true
        
        
        
        
        
        // DELETE ALL REALM FILES!
//        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
//        let realmURLs = [
//            realmURL,
//            realmURL.appendingPathExtension("lock"),
//            realmURL.appendingPathExtension("note"),
//            realmURL.appendingPathExtension("management")
//        ]
//        for URL in realmURLs {
//            do {
//                try FileManager.default.removeItem(at: URL)
//            } catch {
//                // handle error
//                print("this didn't delete it!")
//            }
//        }
//        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

