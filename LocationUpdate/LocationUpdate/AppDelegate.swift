//
//  AppDelegate.swift
//  LocationUpdate
//
//  Created by Mayur on 11/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocationManager.shared.afterResume = false
        LocationManager.shared.addApplicationStatusToPList(applicationStatus: "didFinishLaunchingWithOptions")
        
        if UIApplication.shared.backgroundRefreshStatus == .denied {
            print("The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh")
        } else if UIApplication.shared.backgroundRefreshStatus == .restricted {
            print("The functions of this app are limited because the Background App Refresh is disable.")
        } else {
            if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
                
                // This "afterResume" flag is just to show that he receiving location updates
                // are actually from the key "UIApplicationLaunchOptionsLocationKey"
                LocationManager.shared.afterResume = true
                
                LocationManager.shared.startMonitoringLocation()
                LocationManager.shared.addResumeLocationToPList()
            }
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        LocationManager.shared.restartMonitoringLocation()
        LocationManager.shared.addApplicationStatusToPList(applicationStatus: "applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        LocationManager.shared.addApplicationStatusToPList(applicationStatus: "applicationDidBecomeActive")
        LocationManager.shared.afterResume = true
        LocationManager.shared.startMonitoringLocation()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        LocationManager.shared.addApplicationStatusToPList(applicationStatus: "applicationWillTerminate")
    }


}

