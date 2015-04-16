//
//  LocationManager.swift
//  TableViewTest
//
//  Original Code by Created by David Owens on 7/4/14.
//  Copyright (c) 2014 rhinoIO. All rights reserved.
//

import UIKit
import CoreLocation

var locationMgr:LocationManager = LocationManager()

struct Location{
    var LocationID: String? = ""
    var LocationName: String? = ""
    var LocationPostID: String? = ""
    var LocationSlug: String? = ""
    var LocationTown: String? = ""
    var LocationAddress: String? = ""
    var LocationPostcode: String? = ""
    var LocationLatitude: Double? = 0
    var LocationLongitude: Double? = 0
    var dateTime: NSDate? = NSDate()
    var distance: Double? = 0
}

class LocationManager: NSObject {

    var locations = [Location]()
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    var predicateString: String = ""
    var predicateVars: NSArray = []
    
    func getLocations(){
        
        var tempLocations:NSArray = persistenceHelper.list("Locations", predicateString: predicateString, predicateVars: predicateVars)
        for res:AnyObject in tempLocations{
            
            var resLat = res.valueForKey("location_latitude") as CLLocationDegrees
            var resLon = res.valueForKey("location_longitude") as CLLocationDegrees
            var resCoords:CLLocation = CLLocation(latitude:resLat, longitude:resLon)
            var distance = locationObj.distanceFromLocation(resCoords) as Double
            res.setValue(distance, forKey: "distance")
            
            //sort the results in ascending order by distance into a new array
                //var descriptor: NSSortDescriptor = NSSortDescriptor(key: "distance", ascending: true)
                //sortedVenueResults = res.sortedArrayUsingDescriptors([descriptor])
            
            locations.append(Location(LocationID:res.valueForKey("location_id") as String!,
                LocationName:res.valueForKey("location_name") as String!,
                LocationPostID:res.valueForKey("post_id") as String!,
                LocationSlug:res.valueForKey("location_slug") as String!,
                LocationTown:res.valueForKey("location_town") as String!,
                LocationAddress:res.valueForKey("location_address") as String!,
                LocationPostcode:res.valueForKey("location_postcode") as String!,
                LocationLatitude:res.valueForKey("location_latitude") as Double!,
                LocationLongitude:res.valueForKey("location_longitude") as Double!,
                dateTime:res.valueForKey("location_date_created") as NSDate!,
                distance:res.valueForKey("distance") as Double!))
        }
        
    }
    

    
    func addLocation(LocationID: AnyObject?, LocationName: AnyObject?, LocationPostID: AnyObject?, LocationSlug: AnyObject?, LocationTown: AnyObject?, LocationAddress: AnyObject?, LocationPostcode: AnyObject?, LocationLatitude: AnyObject?, LocationLongitude: AnyObject?, dateTime: AnyObject?){
        
        var dicLocation = [String: AnyObject]()
          dicLocation["location_id"] = LocationID
          dicLocation["location_name"] = LocationName
          dicLocation["post_id"] = LocationPostID
          dicLocation["location_slug"] = LocationSlug
          dicLocation["location_town"] = LocationTown
          dicLocation["location_address"] = LocationAddress
          dicLocation["location_postcode"] = LocationPostcode
          dicLocation["location_latitude"] = LocationLatitude
          dicLocation["location_longitude"] = LocationLongitude
          dicLocation["location_date_created"] = dateTime

        var LocationExistCheck = persistenceHelper.list("Locations", predicateString: "location_id = %@", predicateVars: [LocationID as String])
        if LocationExistCheck.count == 0 {
            if(persistenceHelper.save("Locations", parameters: dicLocation)){
                    println("venue saved")
                
                    // if errors then its probably here as this is untested
                locations.append(Location(LocationID: LocationID as String?, LocationName: LocationName as String?, LocationPostID: LocationPostID as String?, LocationSlug: LocationSlug as String?, LocationTown: LocationTown as String?, LocationAddress: LocationAddress as String?, LocationPostcode: LocationPostcode as String?, LocationLatitude: LocationLatitude as Double?, LocationLongitude: LocationLongitude as Double?, dateTime: dateTime as NSDate?, distance: 0 as Double?))
            }
        } else {

            var existingLocationID = LocationExistCheck[0].valueForKey("location_id") as String
            println("Venue already in database. Location ID: \(existingLocationID)")
        }
    }
    
    func removeLocation(index:Int){
        
        var value:String = locations[index].LocationID!
        
        if(persistenceHelper.remove("Locations", key: "location_id", value: value)){
            locations.removeAtIndex(index)
        }
    }
}

