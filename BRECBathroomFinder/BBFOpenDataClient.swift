//
//  BBFOpenDataClient.swift
//  BRECBathroomFinder
//
//  Created by Jonathan Hooper on 3/18/15.
//  Copyright (c) 2015 JonathanHooper. All rights reserved.
//

import Foundation
import CoreLocation

let BBFAPIEndPoint = "https://data.brla.gov/resource/phg8-g77c.json?$where=%20restroom%20%3E%200"

var sharedBBFOpenDataClient: BBFOpenDataClient!

class BBFOpenDataClient: AFHTTPRequestOperationManager {
    
    class func sharedClient() -> BBFOpenDataClient {
        if sharedBBFOpenDataClient != nil {
            return sharedBBFOpenDataClient
        } else {
            sharedBBFOpenDataClient = BBFOpenDataClient()
            return sharedBBFOpenDataClient
        }
    }
    
    func loadBathroomData(#success: (bathrooms: Array<BBFBathroom>) -> Void, failure: (error: NSError!) -> Void) {
        // Use AFNetworking to load the BREC park data from Baton Rouge Open Data
        self.GET(BBFAPIEndPoint, parameters:nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            // Load the data from the response. Go to the failure block if it can't be loaded
            var bathroomDataArray: Array<(Dictionary<String, AnyObject>)>! = response as? Array<(Dictionary<String, AnyObject>)>
            if bathroomDataArray == nil {
                failure(error: NSError(domain: "BRECBathroomFinder", code: 5624, userInfo: [NSLocalizedDescriptionKey: "Unable to load response from Open Data"]))
                return
            }
            
            // Load the bathrooms from the response data
            var bathrooms = Array<BBFBathroom>()
            for bathroomData in bathroomDataArray {
                let bathroom: BBFBathroom? = self.createBathroomWithData(bathroomData)
                if bathroom != nil {
                    bathrooms.append(self.createBathroomWithData(bathroomData)!)
                }
            }
            
            // Go to the success block with the bathrooms
            success(bathrooms: bathrooms)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            // If AFNetworking fails forward the error
            failure(error: error)
        })
    }
    
    private func createBathroomWithData(data: Dictionary<String, AnyObject>) -> BBFBathroom? {
        // Get the name and geolocation data from the API response data
        let name: String? = data["park_name"] as? String
        let latitude: String? = (data["geolocation"] as Dictionary<String, AnyObject>)["latitude"] as? String
        let longitude: String? = (data["geolocation"] as Dictionary<String, AnyObject>)["longitude"] as? String
        
        // Conditionally get the address
        var address: String?
        if (data["address"] as? String != nil) {
            address = data["address"] as? String
        } else {
            address = ""
        }
        
        // Create the CLLocation
        var location: CLLocation?
        if latitude != nil && longitude != nil {
            location = CLLocation(latitude: NSString(string: latitude!).doubleValue, longitude: NSString(string: longitude!).doubleValue)
        }
        
        // Create and return the bathroom or nil
        if name != nil && address != nil && location != nil {
            return BBFBathroom(name: name!, address: address!, location: location!)
        } else {
            return nil
        }
    }
    
}