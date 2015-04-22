//
//  Comments.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 22/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation

class BAAComment: BAAObject {
    
    var comment: NSString!

    
    
    override init!(dictionary: [NSObject : AnyObject]!) {
        
        comment = dictionary["comment"] as! NSString!

        super.init(dictionary: dictionary)
        
    }

    override func collectionName() -> String! {
        return "document/Comments";
    }
    
}