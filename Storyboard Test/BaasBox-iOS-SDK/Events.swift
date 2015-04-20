//
//  Events.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 19/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation

class BAAEvent: BAAObject {
    
    let event_all_day: Bool
    let event_end: NSDate
    let event_name: NSString
    let event_start: NSDate
    let event_status: NSString
    let location_id: NSString // this is where the link will go but i havent looked that bit up yet
    
    override init!(dictionary: [NSObject : AnyObject]!) {
        event_all_day = dictionary["event_all_day"]! as Bool
        event_end = dictionary["event_end"]! as NSDate
        event_name = dictionary["event_name"]! as NSString
        event_start = dictionary["event_start"]! as NSDate
        event_status = dictionary["event_status"]! as NSString
        location_id = dictionary["location_id"]! as NSString
        super.init(dictionary: dictionary)
    }
    
    override func collectionName() -> String! {
        return "document/Events";
    }
    
}
