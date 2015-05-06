//
//  Venues.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 19/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation




class BAAVenue: BAAObject {
    
    struct MetroArea {
        var uri: AnyObject!
        var id: AnyObject!
        var country = Country()

    }
    
    struct Country{
        var displayName: AnyObject!
    }
    
    struct City{
        var displayName: AnyObject!
        var country = Country()
    }

    var metroArea = MetroArea()
    var city = City()
    var lat: AnyObject! //Done
    var lng: AnyObject! // Done
    var displayName: AnyObject! // Done
    var zip: AnyObject! // Done
    var venue_town: AnyObject!
    var capacity: AnyObject! //Done
    var uri: AnyObject! //Done
    var venue_id: AnyObject! //Done
    var street: AnyObject! //Done
    var website: AnyObject! //Done
    var phone: AnyObject! //Done
    var venue_description: AnyObject! //Done
    
    override init!(dictionary: [NSObject : AnyObject]!) {
        // Just an idea on how to solve the NSNull problem
        // if dictionary["venue_address"]?.type != NSNull() {venue_address = dictionary["venue_address"] as! NSString!}
        
        metroArea.id = dictionary["metroArea"]?.objectForKey("id")
        metroArea.uri = dictionary["metroArea"]?.objectForKey("uri")
        metroArea.country.displayName = dictionary["metroArea"]?.objectForKey("coutry")?.objectForKey("displayName")
        
        city.displayName = dictionary["city"]?.objectForKey("displayName")
        city.country.displayName = dictionary["city"]?.objectForKey("coutry")?.objectForKey("displayName")
        
        lat = dictionary["lng"]
        lng = dictionary["lat"]
        displayName = dictionary["displayName"]
        zip = dictionary["zip"]
        venue_town = dictionary["venue_town"]
        capacity = dictionary["capacity"]
        uri = dictionary["uri"]
        venue_id = dictionary["venue_id"]
        street = dictionary["street"]
        website = dictionary["website"]
        phone = dictionary["phone"]
        venue_description = dictionary["description"]

        super.init(dictionary: dictionary)

    }
    
    override func collectionName() -> String! {
        return "document/Venues";
    }
    
    
    /*
    
    Example Data Set for Venue
    
    {
        "street": "Tatton Park",
        "metroArea": {
            "uri": "http://www.songkick.com/metro_areas/24475-uk-manchester?utm_source=14198&utm_medium=partner",
            "id": 24475,
            "country": {
                "displayName": "UK"
            },
            "displayName": "Manchester"
        },
        "website": "http://www.tattonpark.org.uk/",
        "city": {
            "country": {
                "displayName": "UK"
            },
            "displayName": "Knutsford"
        },
        "zip": "WA16 6QN",
        "phone": null,
        "description": "",
        "lat": 53.33033,
        "capacity": null,
        "lng": -2.3881333,
        "uri": "http://www.songkick.com/venues/28931-tatton-park?utm_source=14198&utm_medium=partner",
        "displayName": "Tatton Park",
        "venue_id": 28931
    }


    */
    
    
}