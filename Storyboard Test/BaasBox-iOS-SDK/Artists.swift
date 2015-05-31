//
//  Artists.swift
//  Avenue
//
//  Created by Neil Oliver on 05/05/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation

class BAAArtist: BAAObject {
    
    let name: AnyObject!
    let sk_artist: AnyObject!
    let mb_artist: AnyObject!

    
    override init!(dictionary: [NSObject : AnyObject]!) {
        
        name = dictionary["name"]
        sk_artist = dictionary["sk_artist"]
        mb_artist = dictionary["mb_aritst"]

        super.init(dictionary: dictionary)
    }
    
    override func collectionName() -> String! {
        return "document/Artists";
    }
}

/*
Example output from aritsts call

{
"sk_artist": 45922833,
"mb_artist": 793332,
"name": "Tom  Mitchell"
}

*/