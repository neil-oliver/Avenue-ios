//
//  LinkedVenueEvents.swift
//  Avenue
//
//  Created by Neil Oliver on 08/05/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation

class BAALinkedVenueEvents: BAAObject {
    
    var venue: BAAVenue!
    var event: BAAEvent!
    
    
    override init!(dictionary: [NSObject : AnyObject]!) {

            venue = BAAVenue(dictionary: dictionary["out"] as! [NSObject : AnyObject])
            event = BAAEvent(dictionary: dictionary["in"] as! [NSObject : AnyObject])

        super.init(dictionary: dictionary)
        
    }
    
}
