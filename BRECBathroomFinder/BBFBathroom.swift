//
//  BBFBathroom.swift
//  BRECBathroomFinder
//
//  Created by Jonathan Hooper on 3/18/15.
//  Copyright (c) 2015 JonathanHooper. All rights reserved.
//

import Foundation
import CoreLocation

class BBFBathroom {
    
    var name: String!
    var address: String!
    var location: CLLocation!
    
    init(name: String, address: String, location: CLLocation) {
        self.name = name
        self.address = address
        self.location = location
    }
    
}