//
//  Venues.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 19/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation




class BAAVenue: BAAObject {

    
    struct Address{
        var street: AnyObject!
        var postcode: AnyObject!
        var city: AnyObject!
        var country: AnyObject!
        var lat: AnyObject!
        var lng: AnyObject!
    }
    
    struct Info{
        var phone: AnyObject!
        var capacity: AnyObject!
        var website: AnyObject!
    }
    
    struct Geometry{
        var osm_id: AnyObject!
        var points: AnyObject!
    }

    var address = Address()
    var info = Info()
    var displayName: AnyObject!
    var sk_id: AnyObject!
    var venue_description: AnyObject!
    var geometry = Geometry()

    override init!(dictionary: [NSObject : AnyObject]!) {
        // Just an idea on how to solve the NSNull problem
        // if dictionary["venue_address"]?.type != NSNull() {venue_address = dictionary["venue_address"] as! NSString!}
        
        address.street = dictionary["address"]?.objectForKey("street")
        address.postcode = dictionary["address"]?.objectForKey("postcode")
        address.city = dictionary["address"]?.objectForKey("city")
        address.country = dictionary["address"]?.objectForKey("country")
        address.lat = dictionary["address"]?.objectForKey("lat")
        address.lng = dictionary["address"]?.objectForKey("lng")
        
        info.phone = dictionary["info"]?.objectForKey("phone")
        info.capacity = dictionary["info"]?.objectForKey("capacity")
        info.website = dictionary["info"]?.objectForKey("website")
        
        geometry.osm_id = dictionary["geometry"]?.objectForKey("osm_id")
        geometry.points = dictionary["geometry"]?.objectForKey("points")

        displayName = dictionary["displayName"]
        sk_id = dictionary["sk_id"]
        venue_description = dictionary["description"]


        super.init(dictionary: dictionary)

    }
    
    override func collectionName() -> String! {
        return "document/Venues";
    }
    
    
    /*
    
    Example Data Set for Venue

    
    {
        "description": "",
        "sk_id": 508206,
        "display_name": "Leeds University Union",
        "address": {
            "street": "Lifton Place, off Clarendon Road",
            "postcode": "LS2 9JT",
            "city": "Leeds",
            "country": "UK",
            "lat": "53.8065644",
            "lng": "-1.55586033267473"
            },
        "info": {
            "phone": "0113 3801 400,",
            "capacity": null,
            "website": "http://www.leedsuniversityunion.org.uk/"
            },
        "geometry": {
            "osm_id": "175997919",
            "points": [
                [
                    [
                        -1.5563989,
                        53.80639
                    ],
                    [
                        -1.5563989,
                        53.80639
                    ]
                ]
            ]
        }
    }

    */
    
    
}