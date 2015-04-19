//
//  Venues.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 19/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation
import CoreLocation

class BAAVenues: BAAObject {
    
    let venue_address: NSString
    let venue_latitude: CLLocationDegrees
    let venue_longitude: CLLocationDegrees
    let venue_name: NSString
    let venue_postcode: NSString
    let venue_slug: NSString
    let venue_town: NSString
    
    
    override init!(dictionary: [NSObject : AnyObject]!) {
        self.venue_address = dictionary["venue_address"]! as NSString
        self.venue_latitude = dictionary["venue_latitude"]! as CLLocationDegrees
        self.venue_longitude = dictionary["venue_longitude"]! as CLLocationDegrees
        self.venue_name = dictionary["venue_name"]! as NSString
        self.venue_postcode = dictionary["venue_postcode"]! as NSString
        self.venue_slug = dictionary["venue_slug"]! as NSString
        self.venue_town = dictionary["venue_town"]! as NSString
        super.init(dictionary: dictionary)
    }
    
    override func collectionName() -> String! {
        return "document/Venues";
    }
    
}