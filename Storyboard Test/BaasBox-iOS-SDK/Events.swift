//
//  Events.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 19/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation

class BAAEvents: BAAObject {
    
    let event_all_day: Bool
    let event_date_modified: NSDate
    let event_end: NSDate
    let event_name: NSString
    let event_start: NSDate
    let event_status: NSString
    let location_id: NSString // this is where the link will go but i havent looked that bit up yet
    
    override init!(dictionary: [NSObject : AnyObject]!) {
        self.event_all_day = dictionary["event_all_day"]! as Bool
        self.event_date_modified = dictionary["event_date_modified"]! as NSDate
        self.event_end = dictionary["event_end"]! as NSDate
        self.event_name = dictionary["event_name"]! as NSString
        self.event_start = dictionary["event_start"]! as NSDate
        self.event_status = dictionary["event_status"]! as NSString
        self.location_id = dictionary["location_id"]! as NSString
        super.init(dictionary: dictionary)
    }
    
    override func collectionName() -> String! {
        return "document/Events";
    }
    
}
