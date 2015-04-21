//
//  Functions.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 02/12/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import CoreImage
import Foundation

    
    var manager: OneShotLocationManager?
    
    func getDistance() -> Bool {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Locations")
        var locres: NSArray = context.executeFetchRequest(request, error: nil)!
        
        // if the query returns results, calculate the distance to each and append to results
        if(locres.count > 0){
            
            for result in locres {
                var resLat = result.valueForKey("location_latitude") as! CLLocationDegrees
                var resLon = result.valueForKey("location_longitude") as! CLLocationDegrees
                var resCoords:CLLocation = CLLocation(latitude:resLat, longitude:resLon)
                var distance = locationObj.distanceFromLocation(resCoords)
                result.setValue(distance, forKey: "distance")
            }
            
            context.save(nil)
            return true
            
        }else{
            
            println("error in calculating or saving distance")
            return false
            
        }
    }
    
    func getCloseEvents(){
        
        if latValue != 0 && lonValue != 0 {
            if getDistance() == true {
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context:NSManagedObjectContext = appDel.managedObjectContext!
                var request = NSFetchRequest(entityName: "Events")
                request.returnsObjectsAsFaults = false;
                request.relationshipKeyPathsForPrefetching = ["locations"]
                request.predicate = NSPredicate(format: "locations.distance < 1000 && event_end > %@", dateTime)
                var eventres: NSArray = context.executeFetchRequest(request, error: nil)!
                var descriptor: NSSortDescriptor = NSSortDescriptor(key: "locations.distance", ascending: true)
                closeEvents = eventres.sortedArrayUsingDescriptors([descriptor]) as! [Events]
            } else {
                println("error getting closest event list")
            }
            
        } else {
            
            //this isnt working yet, possibly a better way to get location
            manager = OneShotLocationManager()
            manager!.fetchWithCompletion {location, error in
                
                // fetch location or an error
                if var loc = location {
                    latValue = loc.coordinate.latitude
                    lonValue = loc.coordinate.longitude
                    locationObj = loc
                    
                    // creates a bounding box to only get venue details within a sort distance of the current location
                    latMax = Double(latValue) + 0.1 //needs location to run, if not then error!!
                    latMin = Double(latValue) - 0.1
                    lngMax = Double(lonValue) + 0.1
                    lngMin = Double(lonValue) - 0.1
                    
                    getCloseEvents()
                    
                } else if var err = error {
                    println(err.localizedDescription)
                }
                manager = nil
            }
        }
        
    }
    
    func existingUserCheck(UserID: Int) -> Bool {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Users")
        request.predicate = NSPredicate(format: "user_id = %i", UserID)
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count != 0 {
            return true
        } else {
            return false
        }
    }
    
    func logInUser(UserID: Int) -> Bool{
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "user_id = %i", UserID)
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        if results.count != 0 {
            let usersManagedObject = results[0] as! Users
            usersManagedObject.user_logged_in = true
            context.save(nil)
            getLoggedInUser()
            return true
        } else {
            return false
        }
        
    }
    
    func getLoggedInUser() -> Bool {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "user_logged_in = %i", 1)
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        if results.count != 0 {
        loggedInUser = results[0] as? Users
            return true
        } else {
            return false
        }
    }

    
    func WhereWhen()->(atVenue: Bool, gigOn: Bool){
        
        var atVenue: Bool = false
        var gigOn: Bool = false
        
        if closeEvents.count != 0 {
            
            //variable for current time
            var currentDateTime = NSDate()
            //time comparison outputs an NSCompareResult object
            var startDateComparisonResult : NSComparisonResult = currentDateTime.compare(closeEvents[0].event_start)
            
            //uses NSCompareResult to assign a value to date to dateComparison variable. 1 = future, 0 = exact time to second, -1 = past
            if startDateComparisonResult == NSComparisonResult.OrderedAscending {
                // Current date is smaller than end date.
                var dateComparison = 1
                closeEvents[0].start_date_comparison_result = dateComparison
            } else if startDateComparisonResult == NSComparisonResult.OrderedDescending {
                // Current date is greater than end date.
                var dateComparison = -1
                closeEvents[0].start_date_comparison_result = dateComparison
                println("date comparison result: \(dateComparison)")
            } else if startDateComparisonResult == NSComparisonResult.OrderedSame {
                // Current date and end date are same.
                var dateComparison = 0
                closeEvents[0].start_date_comparison_result = dateComparison
                println("date comparison result: \(dateComparison)")
            }
            
            //same process as for start date above
            var endDateComparisonResult : NSComparisonResult = currentDateTime.compare(closeEvents[0].event_end)
            
            if endDateComparisonResult == NSComparisonResult.OrderedAscending {
                // Current date is smaller than end date.
                var dateComparison = 1
                closeEvents[0].end_date_comparison_result = dateComparison
            } else if endDateComparisonResult == NSComparisonResult.OrderedDescending {
                // Current date is greater than end date.
                var dateComparison = -1
                closeEvents[0].end_date_comparison_result = dateComparison
                println("date comparison result: \(dateComparison)")
            } else if endDateComparisonResult == NSComparisonResult.OrderedSame {
                // Current date and end date are same.
                var dateComparison = 0
                closeEvents[0].end_date_comparison_result = dateComparison
                println("date comparison result: \(dateComparison)")
            }
            
            
            // nested if statement to work out where the user is and if there is an event listed. println() statements describe each condition of the if statement.
            if closeEvents[0].locations.distance <= 100 {
                println("The Nearest venue to you is \(closeEvents[0].locations.location_name) and you are within 100m")
                
                if closeEvents[0].event_name == "" {
                    println("no event listed for \(closeEvents[0].locations.location_name)")
                    atVenue = true
                    gigOn = false
                } else if closeEvents[0].start_date_comparison_result >= 0 {
                    println("\(closeEvents[0].locations.location_name) has the event \(closeEvents[0].event_name) listed but is in the future")
                    atVenue = true
                    gigOn = false
                } else if closeEvents[0].start_date_comparison_result <= 0 && closeEvents[0].end_date_comparison_result == 1 {
                    println("The event \(closeEvents[0].event_name) is currently happening at \(closeEvents[0].locations.location_name)")
                    atVenue = true
                    gigOn = true
                } else if closeEvents[0].end_date_comparison_result == -1 {
                    println("\(closeEvents[0].locations.location_name) has the event \(closeEvents[0].event_name) listed but it is in the past")
                    atVenue = true
                    gigOn = false
                }
                
                
            } else if closeEvents[0].locations.distance > 100 {
                println("The Nearest venue to you is \(closeEvents[0].locations.location_name) and you are not within 100m")
                
                if closeEvents[0].event_name == "" {
                    println("no event listed for \(closeEvents[0].locations.location_name)")
                    atVenue = false
                    gigOn = false
                } else if closeEvents[0].start_date_comparison_result >= 0 {
                    println("\(closeEvents[0].locations.location_name) has the event \(closeEvents[0].event_name) listed but is in the future")
                    atVenue = false
                    gigOn = false
                } else if closeEvents[0].start_date_comparison_result <= 0 && closeEvents[0].end_date_comparison_result == 1 {
                    println("The event \(closeEvents[0].event_name) is currently happening at \(closeEvents[0].locations.location_name)")
                    atVenue = false
                    gigOn = true
                } else if closeEvents[0].end_date_comparison_result == -1 {
                    println("\(closeEvents[0].locations.location_name) has the event \(closeEvents[0].event_name) listed but it is in the past")
                    atVenue = false
                    gigOn = false
                }
            }
        } else {
            println("closeEvents not yet set")
        }
    
        return (atVenue, gigOn)
    }

    infix operator < {}

    func < (let left:NSDate, let right: NSDate) -> Bool {
        var result:NSComparisonResult = left.compare(right)
        var isEarlier = false
        if (result == NSComparisonResult.OrderedAscending) {
            isEarlier = true
        }
        return isEarlier
    }

    func saveImage(image: UIImage, name: String) {
        //saves image into the default directory using a specified name
        var image = image
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let destinationPath = documentsPath.stringByAppendingPathComponent("\(name).jpg")
        UIImageJPEGRepresentation(image,1.0).writeToFile(destinationPath, atomically: true)
    }



