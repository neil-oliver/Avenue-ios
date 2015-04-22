//
//  Venues.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 19/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation

class BAAVenue: BAAObject {
    
    var venue_address: NSString!
    var venue_latitude: NSNumber!
    var venue_longitude: NSNumber!
    var venue_name: NSString!
    var venue_postcode: NSString!
    var venue_slug: NSString!
    var venue_town: NSString!
    
    
    override init!(dictionary: [NSObject : AnyObject]!) {
        
        venue_address = dictionary["venue_address"] as! NSString!
        venue_latitude = dictionary["venue_latitude"] as! NSNumber!
        venue_longitude = dictionary["venue_longitude"] as! NSNumber!
        venue_name = dictionary["venue_name"] as! NSString!
        venue_postcode = dictionary["venue_postcode"] as! NSString!
        venue_slug = dictionary["venue_slug"] as! NSString!
        venue_town = dictionary["venue_town"] as! NSString!
        super.init(dictionary: dictionary)

    }
    
    override func collectionName() -> String! {
        return "document/Venues";
    }
    
}