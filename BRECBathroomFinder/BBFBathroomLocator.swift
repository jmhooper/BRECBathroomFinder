//
//  BBFBathroomLocator.swift
//  BRECBathroomFinder
//
//  Created by Jonathan Hooper on 3/18/15.
//  Copyright (c) 2015 JonathanHooper. All rights reserved.
//

import Foundation
import CoreLocation

var sharedBBFBathroomLocator: BBFBathroomLocator!

class BBFBathroomLocator {
    
    class func sharedLocator() -> BBFBathroomLocator {
        if sharedBBFBathroomLocator == nil {
            sharedBBFBathroomLocator = BBFBathroomLocator()
        }
        return sharedBBFBathroomLocator
    }
    
    func findBathrooms(#success: (bathrooms: Array<BBFBathroom>) -> Void, failure: (error: NSError) -> Void) {
        BBFOpenDataClient.sharedClient().loadBathroomData(success: { (bathrooms: Array<BBFBathroom>!) -> Void in
            success(bathrooms: bathrooms)
        }, failure: { (error: NSError!) -> Void in
            failure(error: error)
        })
    }
    
    func findBathroomsNearby(#success: (bathrooms: Array<BBFBathroom>) -> Void, failure: (error: NSError) -> Void) {
        BBFLocationManager.sharedManager().requestLocation(success: { (location: CLLocation) in
            self.findBathroomsNearLocation(location, success: { (bathrooms: Array<BBFBathroom>) in
                success(bathrooms: bathrooms)
                }, failure: { (error: NSError) in
                    failure(error: error)
            })
        }, failure: { (error: NSError) in
            failure(error: error)
        })
    }
    
    func findBathroomsNearLocation(location: CLLocation, success: (bathrooms: Array<BBFBathroom>) -> Void, failure: (error: NSError) -> Void){
        self.findBathrooms(success: { (bathrooms: Array<BBFBathroom>) in
            // Sort the array by distance
            var sortedBathrooms = bathrooms.sorted({ (bathroomA, bathroomB) -> Bool in
                return location.distanceFromLocation(bathroomA.location) < location.distanceFromLocation(bathroomB.location)
            })
            success(bathrooms: sortedBathrooms)
        }, failure: { (error: NSError) in
            // Forward the error
            failure(error: error)
        })
    }
    
}