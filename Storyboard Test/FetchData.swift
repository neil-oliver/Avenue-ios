//
//  FetchData.swift
//  TableViewTest
//
//  Created by Neil Oliver on 17/11/2014.
//  Copyright (c) 2014 rhinoIO. All rights reserved.
//


/*
current problems: no default values if information is not included in JSON


*/

import UIKit
import CoreData
import CoreLocation

class FetchData: NSObject, NSURLConnectionDelegate {
    
    //variable for tracking the time taken to run the NSURLConnection request
    var tick = NSDate()
    
    // variable to call the OneShotLocationManager class
    var manager: OneShotLocationManager?
    
    //variable to hold data from NSURLConnection request
    lazy var data = NSMutableData()
    
    //variables for holdsing values from the NSURLConnection request
    var LocationName, LocationPostID, LocationID, LocationSlug, LocationTown, LocationAddress, LocationPostcode, LocationLatitude, LocationLongitude, EventName, EventPostID, EventLocationID, EventStartDate, EventEndDate, EventStartTime, EventEndTime, EventAllDay, EventOwner, EventStatus, EventStart, EventEnd, currentDateTime : AnyObject!
    
   
    //creates an NSURLConnectionRequest
    func startConnection(lat: CLLocationDegrees = latValue, lon: CLLocationDegrees = lonValue){
        //records current timebefore request
        tick = NSDate()
        
        var urlPath: String = ""
        
        if lat != latValue && lon != lonValue {
            
            urlPath = "http://bethehype.co.uk/service.php?lat=\(lat)&lon=\(lon)&update=events"
            var url: NSURL = NSURL(string: urlPath)!
            var request: NSURLRequest = NSURLRequest(URL: url)
            var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
            connection.start()
            println(urlPath)
            
        } else {
        
            //checks to see if the current location is set before starting connection. if its not it calls LocationManager
            if latValue != 0 && lonValue != 0 {
                
                //sets URL path for request using current lat and lon values
                //setup required for NSURLConnection request
                urlPath = "http://bethehype.co.uk/service.php?lat=\(latValue)&lon=\(lonValue)&update=events"
                var url: NSURL = NSURL(string: urlPath)!
                var request: NSURLRequest = NSURLRequest(URL: url)
                var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
                connection.start()
                println(urlPath)
                
            } else {
                
                manager = OneShotLocationManager()
                manager!.fetchWithCompletion {location, error in
                    
                    // fetch location or an error
                    if var loc = location {
                        println(location)
                        //assigns values to variables for current latitude and logitude
                        latValue = loc.coordinate.latitude
                        lonValue = loc.coordinate.longitude
                        
                        //assigns a location object to variable
                        locationObj = loc
                        //sets URL path for request using current lat and lon values
                        //setup required for NSURLConnection request
                        urlPath = "http://bethehype.co.uk/service.php?lat=\(latValue)&lon=\(lonValue)&update=events"
                        var url: NSURL = NSURL(string: urlPath)!
                        var request: NSURLRequest = NSURLRequest(URL: url)
                        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
                        connection.start()
                        println(urlPath)

                        
                        
                    } else if var err = error {
                        println(err.localizedDescription)
                    }
                    self.manager = nil
                }
                
                //alertMessage = "Unable to get Location"
                //self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    //adds data recieved from the NSURLConnection request to the data variable
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        
        self.data.appendData(data)
    }
    
    //when all of the data from the NSURLConnection request has been recieved, interpret results as JSON and extract information into variables
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var jsonError: NSError?
        let jsonResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)
        let json = JSON(data: data)
        
        //creates a new variable that calculates the time between the start of the timer and now.
        let timeSinceTick = tick.timeIntervalSinceNow
        println("Time taken to run request: \(timeSinceTick)")
        
        //breaks the JSON results into locations and events
        var venueResultNo = 0
        var eventResultNo = 0
        var Venues = json["results"]["locations"]
        var Events = json["results"]["events"]
        var venueResultsCount = json["results"]["locations"].count
        var eventResultsCount = json["results"]["events"].count
        println("Event results count: \(eventResultsCount)")
        println("Venue results count: \(venueResultsCount)")
        
        //extract each part of the JSON into variables
        while (venueResultNo < venueResultsCount){
            LocationName = Venues[venueResultNo]["location_name"].string
            LocationPostID = Venues[venueResultNo]["post_id"].string
            LocationID = Venues[venueResultNo]["location_id"].string
            LocationSlug = Venues[venueResultNo]["location_slug"].string
            LocationTown = Venues[venueResultNo]["location_town"].string
            LocationAddress = Venues[venueResultNo]["location_address"].string
            LocationPostcode = Venues[venueResultNo]["location_postcode"].string
            LocationLatitude = Venues[venueResultNo]["location_latitude"].doubleValue
            LocationLongitude = Venues[venueResultNo]["location_longitude"].doubleValue
            currentDateTime = NSDate()
            venueResultNo = venueResultNo + 1
            
            //calls the venue save function
            locationMgr.addLocation(LocationID, LocationName: LocationName, LocationPostID: LocationPostID, LocationSlug: LocationSlug, LocationTown: LocationTown, LocationAddress: LocationAddress, LocationPostcode: LocationPostcode, LocationLatitude: LocationLatitude, LocationLongitude: LocationLongitude, dateTime: currentDateTime)
        }
        
        while (eventResultNo < eventResultsCount){
            EventName = Events[eventResultNo]["event_name"].string
            EventPostID = Events[eventResultNo]["post_id"].string
            EventLocationID = Events[eventResultNo]["location_id"].string
            EventStartDate = Events[eventResultNo]["event_start_date"].string
            EventEndDate = Events[eventResultNo]["event_end_date"].string
            EventStartTime = Events[eventResultNo]["event_start_time"].string
            EventEndTime = Events[eventResultNo]["event_end_time"].string
            EventAllDay = Events[eventResultNo]["event_all_day"].string
            EventOwner = Events[eventResultNo]["event_owner"].string
            EventStatus = Events[eventResultNo]["event_status"].string
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let EventStartDateTime : String = "\(EventStartDate) \(EventStartTime)"
            let EventEndDateTime : String = "\(EventEndDate) \(EventEndTime)"
            EventStart = dateFormatter.dateFromString(EventStartDateTime)
            EventEnd = dateFormatter.dateFromString(EventEndDateTime)
            currentDateTime = NSDate()
            eventResultNo = eventResultNo + 1
            EventSave()

        }
        
        
        //println(json)
        //clear the data variable for if a second NSURLConnection request is made
        self.data = NSMutableData()
        getCloseEvents()
    }

    
    /********************************
    need to sort the problem using the Events Manager to Save the data. for a temp solution, it is using the old eventSave script.
    *////////////////////////////////

    
    //saves event data from the NSURLConnection request to the local phone (core data) database
    func EventSave(){
        
        //first a database query is done to check if the event id is already in the local database
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Events")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "post_id = %@", "\(EventPostID)")
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        // if no results are returned then the data is saved
        if(results.count == 0 && EventPostID != nil){
            
            var newEvent = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: context) as Events
            
            newEvent.location_id = EventLocationID as NSString
            newEvent.event_name = EventName as NSString
            newEvent.post_id = EventPostID as NSString
            newEvent.event_start_date = EventStartDate as NSString
            newEvent.event_end_date = EventEndDate as NSString
            newEvent.event_start_time = EventStartTime as NSString
            newEvent.event_end_time = EventEndTime as NSString
            newEvent.event_date_created = dateTime as NSDate
            newEvent.event_all_day  = EventAllDay as NSString
            newEvent.event_status = EventStatus as NSString
            newEvent.event_owner = EventOwner as NSString
            newEvent.event_start = EventStart as NSDate
            newEvent.event_end = EventEnd as NSDate
            
            func getLocationObject(LocationID: String)->Locations{
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
                var context:NSManagedObjectContext = appDel.managedObjectContext!
                
                var request = NSFetchRequest(entityName: "Locations")
                request.returnsObjectsAsFaults = false;
                request.predicate = NSPredicate(format: "location_id = %@", LocationID)
                var results:NSArray = context.executeFetchRequest(request, error: nil)!
                
                let locationObject = results[0] as Locations
                return locationObject
            }
            
            newEvent.locations = getLocationObject(EventLocationID as String)
            context.save(nil)
            
            println("new event: \(newEvent)")
            
            //if the location id is found in the database a message is printed in the console and the data is not saved.
        }else if (results.count > 0){
            
            var res = results[0] as NSManagedObject
            var existingEvent = res.valueForKey("post_id") as String
            println("Event already in database. Event ID: \(existingEvent)")
            
        }else{
            
            println("event save error")
            
        }
    }
}
