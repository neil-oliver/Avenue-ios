//
//  Events.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 19/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation

class BAAEvent: BAAObject {
    
    struct Start {
        var time: AnyObject!
        var datetime: AnyObject!
        var date: AnyObject!
        var is_estimate: Bool!
    }
    
    struct End {
        var time: AnyObject!
        var datetime: AnyObject!
        var date: AnyObject!
        var is_estimate: Bool!
    }

    
    struct Artist {
        var artist_id: AnyObject!
        var billingIndex: AnyObject!
    }
    
    var type: AnyObject!
    var status: AnyObject!
    var ageRestriction: AnyObject!
    var uri: AnyObject!
    var displayName: AnyObject!
    var popularity: AnyObject!
    var event_id: AnyObject!
    var venue_id: AnyObject!
    var start = Start()
    var end = End()
    var artistArray: NSArray!
    var artist = Artist()
    var artists = [Artist]()
    
    override init!(dictionary: [NSObject : AnyObject]!) {
        type = dictionary["type"]
        status = dictionary["status"]
        ageRestriction = dictionary["ageRestriction"]
        uri = dictionary["uri"]
        displayName = dictionary["name"]
        popularity = dictionary["popularity"]
        event_id = dictionary["event_id"]
        venue_id  = dictionary["venue_id"]
        start.date = dictionary["start"]?.objectForKey("date")
        start.datetime = dictionary["start"]?.objectForKey("datetime")
        start.time = dictionary["start"]?.objectForKey("time")
        start.is_estimate = dictionary["start"]?.objectForKey("is_estimate") as? Bool
        end.date = dictionary["start"]?.objectForKey("date")
        end.datetime = dictionary["start"]?.objectForKey("datetime")
        end.time = dictionary["start"]?.objectForKey("time")
        end.is_estimate = dictionary["start"]?.objectForKey("is_estimate") as? Bool
        
        //builds an array of artists at the event
        artistArray = dictionary["artists"] as! NSArray
        for item in artistArray {
            artist.artist_id = item.valueForKey("artist_id")
            artist.billingIndex = item.valueForKey("billingIndex")
            artists.append(artist)
        }
        super.init(dictionary: dictionary)
    }
    
    override func collectionName() -> String! {
        return "document/Events";
    }
    
    /* Example output from BAAS

    {
        "type": "Concert",
        "status": "ok",
        "ageRestriction": null,
        "start": {
            "time": "19:30:00",
            "datetime": "2015-05-05T19:30:00+0100",
            "date": "2015-05-05"
        },
        "uri": "http://www.songkick.com/concerts/22922693-uriah-heep-at-motion-and-the-marble-factory?utm_source=14198&utm_medium=partner",
        "displayName": "Uriah Heep at Motion & the Marble Factory (May 5, 2015)",
        "popularity": 0.019591,
        "artist": [
            {
            "artist_id": 45344778,
            "billingIndex": 1
            }
        ],
        "event_id": 22922693,
        "venue_id": 2745098
    }

*/

}
