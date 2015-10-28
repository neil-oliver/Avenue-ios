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
            let parameters: NSDictionary = ["where" : "distance(lat,lng,\(latValue),\(lonValue)) < 5"]
            BAAVenue.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(venues:[AnyObject]!, error:NSError!) -> Void in
                if venues != nil {
                    for venue in venues {
                        print(venue, terminator: "\n")
                        let singlevenue: BAAVenue = venue as! BAAVenue
                        print("Venue Name: \(singlevenue.displayName)", terminator: "\n")
                    }
                }
                if error != nil {
                    print("Error: \(error)", terminator: "\n")
                }
            })

        } else {
            
            manager = OneShotLocationManager()
            manager!.fetchWithCompletion {location, error in
                
                // fetch location or an error
                if let loc = location {
                    print(location, terminator: "\n")
                    //assigns values to variables for current latitude and logitude
                    latValue = loc.coordinate.latitude
                    lonValue = loc.coordinate.longitude
                    
                    //assigns a location object to variable
                    locationObj = loc

                    // Assumes BAAVenue as a subclass of BAAObject
                    let parameters: NSDictionary = ["where" : "distance(lat,lng,\(latValue),\(lonValue)) < 5"]
                    BAAVenue.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(venues:[AnyObject]!, error:NSError!) -> Void in
                        if venues != nil {
                            for venue in venues {
                                print(venue, terminator: "\n")
                                let singlevenue: BAAVenue = venue as! BAAVenue
                                closeVenues.append(singlevenue)
                                print("Venue Name: \(singlevenue.displayName)", terminator: "\n")
                                
                            }
                        }
                        if error != nil {
                            print("Error: \(error)", terminator: "\n")
                        }
                    })
                    
                    
                    
                } else if let err = error {
                    print(err.localizedDescription, terminator: "\n")
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
                if let loc = location {
                    print(location, terminator: "\n")
                    //assigns values to variables for current latitude and logitude
                    latValue = loc.coordinate.latitude
                    lonValue = loc.coordinate.longitude
                    
                    //assigns a location object to variable
                    locationObj = loc
                    
                    completion(locationSet: true)
                    
                } else if let err = error {
                    print(err.localizedDescription, terminator: "\n")
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
            print("getting linked venues and events", terminator: "\n")
            let path: NSString = "link"
            let params: NSDictionary = ["fields" : "out, in, distance(out.address.lat,out.address.lng,\(latValue),\(lonValue)) as distance", "where" : "distance(out.address.lat,out.address.lng,\(latValue),\(lonValue)) < 5 and in.start.datetime > date('\(formattedDateTime)') and label=\"venue_event\"", "orderBy": "distance asc"]
            
            let c = BAAClient.sharedClient()
            
            c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                print(success, terminator: "\n")
                let data: NSDictionary = success as! NSDictionary
                let dataArray: [AnyObject] = data["data"] as! [AnyObject]
                closeVenueEvents = []

                for item in dataArray {
                    
                    let venueAndEvent = BAALinkedVenueEvents(dictionary: item as! [NSObject : AnyObject])
                    closeVenueEvents.append(venueAndEvent)
                    print(venueAndEvent.event.displayName, terminator: "\n")
                    print(venueAndEvent.event.start.datetime, terminator: "\n")
                    print("Distance: \(venueAndEvent.distance)", terminator: "\n")
                    print("\(closeVenueEvents.count) events were found and saved to your device!", terminator: "\n")
                    completion(getBassVenuesEventsResult: true)
                }
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    print(failure, terminator: "\n")
                    
            })
        }
    }
    
    func getVenuesWithLinks(completion: (getBassVenuesWithLinksResult: Bool) -> Void){
        print("getting venues with links", terminator: "\n")
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            let path: NSString = "link"
            let params: NSDictionary = ["fields" : "DISTINCT(out) as out, distance(out.address.lat,out.address.lng,\(latValue),\(lonValue)) as distance", "where" : "distance(out.address.lat,out.address.lng,\(latValue),\(lonValue)) < 5 and in.start.datetime > date('\(formattedDateTime)') and label=\"venue_event\"", "orderBy": "distance asc"]
            
            let c = BAAClient.sharedClient()
            
            c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                print(success, terminator: "\n")
                let data: NSDictionary = success as! NSDictionary
                let dataArray: [AnyObject] = data["data"] as! [AnyObject]
                venuesWithLinks = []

                for item in dataArray {
                    if let out = item["out"]! {
                        let venue = BAAVenue(dictionary: out as! [NSObject : AnyObject])
                        venuesWithLinks.append(venue)
                    }
                }
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    print(failure, terminator: "\n")
                    
            })
        }
    }
    
    func getNewEvents(completion: (result: Bool) -> Void){
        
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            let api = "io09K9l3ebJxmxe2"
            let path: NSString = "plugin/avenue.event_management?apikey=\(api)&location=geo:\(latValue),\(lonValue)"
            let params: NSDictionary = ["" : ""]
            //var params: NSDictionary = ["api" : "io09K9l3ebJxmxe2", "location" : "geo:\(latValue),\(lonValue)"]
            let c = BAAClient.sharedClient()
            
            c.postPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                
                    print("new events successfully added by baasbox plugin", terminator: "\n")
                    //print(success, appendNewline: true)
                
                completion(result: true)
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    print(failure, terminator: "\n")
                    
            })
        }
    }
}
