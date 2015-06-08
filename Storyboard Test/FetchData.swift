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
    

    func getBassVenues(){
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            
            // Assumes BAAVenue as a subclass of BAAObject
            var parameters: NSDictionary = ["where" : "distance(lat,lng,\(latValue),\(lonValue)) < 5"]
            BAAVenue.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(venues:[AnyObject]!, error:NSError!) -> Void in
                if venues != nil {
                    for venue in venues {
                        println(venue)
                        var singlevenue: BAAVenue = venue as! BAAVenue
                        println("Venue Name: \(singlevenue.displayName)")
                        println("Metro Area: \(singlevenue.metroArea.id)")
                    }
                }
                if error != nil {
                    println("Error: \(error)")
                }
            })

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

                    // Assumes BAAVenue as a subclass of BAAObject
                    var parameters: NSDictionary = ["where" : "distance(lat,lng,\(latValue),\(lonValue)) < 5"]
                    BAAVenue.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(venues:[AnyObject]!, error:NSError!) -> Void in
                        if venues != nil {
                            for venue in venues {
                                println(venue)
                                var singlevenue: BAAVenue = venue as! BAAVenue
                                println("Venue Name: \(singlevenue.displayName)")
                                println("Metro Area: \(singlevenue.metroArea.id)")
                                
                            }
                        }
                        if error != nil {
                            println("Error: \(error)")
                        }
                    })
                    
                    
                    
                } else if var err = error {
                    println(err.localizedDescription)
                    let alertController = UIAlertController(title: "Failed to find location", message:
                        "Location error \(err.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                }
                self.manager = nil
            }
        }
    }
    
    func getLocation(completion: (locationSet: Bool) -> Void) {
        if latValue == 0 && lonValue == 0 {
        
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
                    
                    completion(locationSet: true)
                    
                } else if var err = error {
                    println(err.localizedDescription)
                    let alertController = UIAlertController(title: "Failed to find location", message:
                        "Location error \(err.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                }
                self.manager = nil
            }
        } else {
            completion(locationSet: true)
        }
    }
    
    func getBassVenuesEvents(completion: (getBassVenuesEventsResult: Bool) -> Void){
        
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            println("getting venues and events")
            var path: NSString = "link"
            var params: NSDictionary = ["fields" : "out, in, distance(out.lat,out.lng,\(latValue),\(lonValue)) as distance", "where" : "distance(out.lat,out.lng,\(latValue),\(lonValue)) < 5 and in.start.datetime > date('\(formattedDateTime)') and label=\"venue_event\"", "orderBy": "distance asc"]
            
            var c = BAAClient.sharedClient()
            
            c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                var data: NSDictionary = success as! NSDictionary
                var dataArray: [AnyObject] = data["data"] as! [AnyObject]
                closeVenueEvents = []

                for item in dataArray {
                    
                    var venueAndEvent = BAALinkedVenueEvents(dictionary: item as! [NSObject : AnyObject])
                    closeVenueEvents.append(venueAndEvent)
                    println(venueAndEvent.event.displayName)
                    println(venueAndEvent.event.start.datetime)
                    println("Distance: \(venueAndEvent.distance)")
                    completion(getBassVenuesEventsResult: true)
                }
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    println(failure)
                    
            })
        }
    }
    
    func getNewEvents(completion: (result: Bool) -> Void){
        
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            println("checking for new events")
            var path: NSString = "plugin/avenue.event_management?apikey=io09K9l3ebJxmxe2&location=geo:\(latValue),\(lonValue)"
            var params: NSDictionary = ["" : ""]
            //var params: NSDictionary = ["api" : "io09K9l3ebJxmxe2", "location" : "geo:\(latValue),\(lonValue)"]
            var c = BAAClient.sharedClient()
            
            c.postPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                
                    println("new events successfully added")
                
                completion(result: true)
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    println(failure)
                    
            })
        }
    }
}
