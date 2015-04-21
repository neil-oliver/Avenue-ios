//
//  EventManager.swift
//  TableViewTest
//
//  Original Code by Created by David Owens on 7/4/14.
//  Copyright (c) 2014 rhinoIO. All rights reserved.
//

import UIKit

var eventMgr:EventManager = EventManager()

struct Event{
    var EventLocationID: String? = ""
    var EventName: String? = ""
    var EventPostID: String? = ""
    var EventAllDay: String? = ""
    var EventStatus: String? = ""
    var EventOwner: String? = ""
    var EventStartDate: String? = ""
    var EventEndDate: String? = ""
    var EventStartTime: String? = ""
    var EventEndTime: String? = ""
    var dateTime: NSDate? = NSDate()
    var EventStart: NSDate? = NSDate()
    var EventEnd: NSDate? = NSDate()
}

class EventManager: NSObject {
    
    var events = [Event]()
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    var predicateString: String = ""
    var predicateVars: NSArray = []
    
    func getEvents(){
        
        var tempEvents:NSArray = persistenceHelper.list("Events", predicateString: predicateString, predicateVars: predicateVars)
        for res:AnyObject in tempEvents{
            
            events.append(Event(EventLocationID:res.valueForKey("location_id") as! String!,
                EventName:res.valueForKey("event_name") as! String!,
                EventPostID:res.valueForKey("post_id") as! String!,
                EventAllDay:res.valueForKey("event_all_day") as! String!,
                EventStatus:res.valueForKey("event_status") as! String!,
                EventOwner:res.valueForKey("event_owner") as! String!,
                EventStartDate:res.valueForKey("event_start_date") as! String!,
                EventEndDate:res.valueForKey("event_end_date") as! String!,
                EventStartTime:res.valueForKey("event_start_time") as! String!,
                EventEndTime:res.valueForKey("event_end_time") as! String!,
                dateTime:res.valueForKey("event_date_created") as! NSDate!,
                EventStart:res.valueForKey("event_start") as! NSDate!,
                EventEnd:res.valueForKey("event_end") as! NSDate!))
        }
        
    }
    
    func addEvent(EventLocationID: AnyObject?, EventName: AnyObject?, EventPostID: AnyObject?, EventAllDay: AnyObject?, EventStatus: AnyObject?, EventOwner: AnyObject?, EventStartDate: AnyObject?, EventEndDate: AnyObject?, EventStartTime: AnyObject?, EventEndTime: AnyObject?, dateTime: AnyObject?, EventStart: AnyObject?, EventEnd: AnyObject?){
        
            var dicEvent = [String: AnyObject]()
            dicEvent["location_id"] = EventLocationID
            dicEvent["event_name"] = EventName
            dicEvent["post_id"] = EventPostID
            dicEvent["event_all_day"] = EventAllDay
            dicEvent["event_status"] = EventStatus
            dicEvent["event_owner"] = EventOwner
            dicEvent["event_start_date"] = EventStartDate
            dicEvent["event_end_date"] = EventEndDate
            dicEvent["event_start_time"] = EventStartTime
            dicEvent["event_end_time"] = EventEndTime
            dicEvent["event_date_created"] = dateTime
            dicEvent["event_start"] = EventStart
            dicEvent["event_end"] = EventEnd
        
        var EventExistCheck = persistenceHelper.list("Events", predicateString: "post_id = %@", predicateVars: [EventPostID as! String])
        if EventExistCheck.count == 0 {
            println("event saved")
            if(persistenceHelper.save("Events", parameters: dicEvent)){
                events.append(Event(EventLocationID: EventLocationID as! String?, EventName: EventName as! String?, EventPostID: EventPostID as! String?, EventAllDay: EventAllDay as! String?, EventStatus: EventStatus as! String?, EventOwner: EventOwner as! String?, EventStartDate: EventStartDate as! String?, EventEndDate: EventEndDate as! String?, EventStartTime: EventStartTime as! String?, EventEndTime: EventEndTime as! String?, dateTime: dateTime as! NSDate?, EventStart: EventStart as! NSDate?, EventEnd: EventEnd as! NSDate?))
            }
        } else {
            
            var existingEventPostID = EventExistCheck[0].valueForKey("post_id") as! String
            println("Event already in database. Event ID: \(existingEventPostID)")
        }
    }
    
    func removeEvent(index:Int){
        
        var value:String = events[index].EventPostID!
        
        if(persistenceHelper.remove("Events", key: "post_id", value: value)){
            events.removeAtIndex(index)
        }
    }
    
}

