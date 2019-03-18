//
//  LocationManager.swift
//  LocationUpdate
//
//  Created by Mayur on 11/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    var anotherLocationManager: CLLocationManager?
    
    var myLastLocation: CLLocationCoordinate2D?
    var myLastLocationAccuracy: CLLocationAccuracy?

    
    var myLocation: CLLocationCoordinate2D?
    var myLocationAccuracy: CLLocationAccuracy?
    
    var myLocationDictInPlist: [AnyHashable : Any]?
    var myLocationArrayInPlist: [AnyObject]?
    
    var afterResume: Bool = false
    
    private override init() {
        super.init()
    }
    
    func startMonitoringLocation() {
        if (anotherLocationManager != nil) {
            anotherLocationManager?.stopMonitoringSignificantLocationChanges()
        }
        
        self.anotherLocationManager = CLLocationManager.init()
        self.anotherLocationManager?.delegate = self
        self.anotherLocationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.anotherLocationManager?.activityType = CLActivityType.otherNavigation
        self.anotherLocationManager?.requestAlwaysAuthorization()
        self.anotherLocationManager?.startMonitoringSignificantLocationChanges()
        self.anotherLocationManager?.allowsBackgroundLocationUpdates = true
    }
    
    func restartMonitoringLocation() {
        self.anotherLocationManager?.stopMonitoringSignificantLocationChanges()
        self.anotherLocationManager?.requestAlwaysAuthorization()
        self.anotherLocationManager?.startMonitoringSignificantLocationChanges()
        self.anotherLocationManager?.allowsBackgroundLocationUpdates = true
    }
    
    func addResumeLocationToPList() {
        print("addResumeLocationToPList")
        
        self.myLocationDictInPlist = [:]
        self.myLocationDictInPlist?["Resume"] = "UIApplicationLaunchOptionsLocationKey"
        self.myLocationDictInPlist?["AppState"] = self.appState()
        self.myLocationDictInPlist?["Time"] = Date.init()
        
        self.saveLocationsToPlist()
    }
    
    func addLocationToPList(fromResume: Bool) {
        print("addLocationToPList")
        
        self.myLocationDictInPlist = [:]
        self.myLocationDictInPlist?["Latitude"] = self.myLocation?.latitude
        self.myLocationDictInPlist?["Longitude"] = self.myLocation?.longitude
        self.myLocationDictInPlist?["Accuracy"] = self.myLocationAccuracy
        self.myLocationDictInPlist?["AppState"] = self.appState()
        if fromResume {
            self.myLocationDictInPlist?["AddFromResume"] = true
        } else {
            self.myLocationDictInPlist?["AddFromResume"] = false
        }
        self.myLocationDictInPlist?["Time"] = Date.init()
        
        self.saveLocationsToPlist()
        
    }
    
    func addApplicationStatusToPList(applicationStatus: String) {
        print("addApplicationStatusToPList")
        
        self.myLocationDictInPlist = [:]
        self.myLocationDictInPlist?["applicationStatus"] = applicationStatus
        self.myLocationDictInPlist?["AppState"] = self.appState()
        self.myLocationDictInPlist?["Time"] = Date.init()
        
        self.saveLocationsToPlist()
    }
    
    func appState() -> String {
        switch UIApplication.shared.applicationState {
        case .active:
            return "UIApplicationStateActive"
        case .background:
            return "UIApplicationStateBackground"
        case .inactive:
            return "UIApplicationStateInactive"
        }
    }
    
    func saveLocationsToPlist() {
        let plistName = "LocationArray.plist"
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = paths[0]
        let fullPath = "\(docDir)/\(plistName)"
        
        var savedProfile = NSDictionary(contentsOfFile: fullPath) as! [AnyHashable : Any]
        
        if savedProfile["LocationArray"] == nil {
            savedProfile = [AnyHashable : Any]()
            myLocationArrayInPlist = [AnyObject]()
        } else {
            myLocationArrayInPlist = savedProfile["LocationArray"] as? [AnyObject]
        }
        
        if (myLocationDictInPlist != nil) {
            myLocationArrayInPlist?.append(myLocationDictInPlist as AnyObject)
            savedProfile["LocationArray"] = myLocationArrayInPlist
        }
        
        if !((savedProfile as NSDictionary).write(toFile: fullPath, atomically: false)) {
            print("Couldn't save LocationArray.plist")
        }
    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager didUpdateLocations: \(locations)")
        for location in locations {
            myLocation = location.coordinate
            myLocationAccuracy = location.horizontalAccuracy
        }
        self.addLocationToPList(fromResume: afterResume)
    }
}
