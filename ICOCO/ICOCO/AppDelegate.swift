//
//  AppDelegate.swift
//  ICOCO
//
//  Created by 구홍석 on 2018. 1. 21..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit
import CoreData

// MARK: - AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder {
    // MARK: Variable
    var window: UIWindow?

    // MARK: Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ICOCO")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if nil != error {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                prLog(error?.localizedDescription)
            }
        })
        return container
    }()

    // MARK: Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                prLog(error.localizedDescription)
            }
        }
    }
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
}
