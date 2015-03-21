//
//  BBFLocationManager.swift
//  BRECBathroomFinder
//
//  Created by Jonathan Hooper on 3/18/15.
//  Copyright (c) 2015 JonathanHooper. All rights reserved.
//

import Foundation
import CoreLocation

class BBFLocationRequest: NSObject {
    var success: ((location: CLLocation) -> Void)!
    var failure: ((error: NSError) -> Void)!
}

var sharedBBFLocationManager: BBFLocationManager!

class BBFLocationManager : CLLocationManager, CLLocationManagerDelegate {
    
    var locationRequests: Array<BBFLocationRequest> = Array<BBFLocationRequest>()
    var isLoadingLocation: Bool = false
    
    class func sharedManager() -> BBFLocationManager {
        if sharedBBFLocationManager == nil {
            sharedBBFLocationManager = BBFLocationManager()
            sharedBBFLocationManager.desiredAccuracy = CLLocationAccuracy(100.0)
            sharedBBFLocationManager.delegate = sharedBBFLocationManager
        }
        return sharedBBFLocationManager
    }
    
    func requestLocation(#success: (location: CLLocation) -> Void, failure: (error: NSError) -> Void) {
        // Create and store a Location Request
        var locationRequest = BBFLocationRequest()
        locationRequest.success = success
        locationRequest.failure = failure
        self.locationRequests.append(locationRequest)
        
        // Don't start updating locations if they have already started being updated
        if self.isLoadingLocation {
            return
        } else {
            self.isLoadingLocation = true
        }
        
        // Respond based on authorization status
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            self.requestWhenInUseAuthorization()
        } else {
            failure(error: NSError(domain: "BBFLocationManager", code: 6578, userInfo: [NSLocalizedDescriptionKey: "Location services are not authorized"]))
        }
    }
    
    
    // LocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        // Stop updates to process the requests
        self.stopUpdatingLocation()
        
        // Return errors to all the requests
        let copiedRequests = self.locationRequests
        for locationRequest: BBFLocationRequest in copiedRequests {
            // Forward the error
            locationRequest.failure(error: error)
            // Remove the request
            self.removeLocationRequest(locationRequest)
        }
        
        // Restart updates if the requests array has not reached 0
        if self.locationRequests.count != 0 {
            self.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: Array<AnyObject>) {
        // Stop updates to process the requests
        self.stopUpdatingLocation()
        
        // Return success to all requests
        let copiedRequests = self.locationRequests
        for locationRequest: BBFLocationRequest in copiedRequests {
            // Forward the error
            locationRequest.success(location: self.location)
            // Remove the request
            self.removeLocationRequest(locationRequest)
        }
        
        // Restart updates if the requests array has not reached 0
        if self.locationRequests.count != 0 {
            self.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.startUpdatingLocation()
        } else {
            // Return errors to all the requests
            let copiedRequests = self.locationRequests
            for locationRequest: BBFLocationRequest in copiedRequests {
                // Forward the error
                locationRequest.failure(error: NSError(domain: "BBFLocationManager", code: 4954, userInfo: [NSLocalizedDescriptionKey: "Location services are not authorized"]))
                // Remove the request
                self.removeLocationRequest(locationRequest)
            }
        }
    }
    
    private func removeLocationRequest(locationRequest: BBFLocationRequest) {
        // Remove the element from the location request array
        if let index = find(self.locationRequests, locationRequest) {
            self.locationRequests.removeAtIndex(index)
        }
        
        // If the requests array has reached 0, stop updating
        if self.locationRequests.count == 0 {
            self.stopUpdatingLocation()
            self.isLoadingLocation = false
        }
    }
}