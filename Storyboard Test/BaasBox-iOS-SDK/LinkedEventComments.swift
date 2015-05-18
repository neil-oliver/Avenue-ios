
//
//  LinkedEventComments.swift
//  Avenue
//
//  Created by Neil Oliver on 17/05/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation

class BAALinkedEventComments: BAAObject {
    
    var event: BAAEvent!
    var comment: BAAComment!
    var file: BAAFile!
    
    override init!(dictionary: [NSObject : AnyObject]!) {
        
        if dictionary["out"]?.objectForKey("@class") as! NSString == "Comments" {
        comment = BAAComment(dictionary: dictionary["out"] as! [NSObject : AnyObject])
        }
        
        if dictionary["out"]?.objectForKey("@class") as! NSString == "_BB_File" {
            file = BAAFile(dictionary: dictionary["out"] as! [NSObject : AnyObject])
        }
        
        event = BAAEvent(dictionary: dictionary["in"] as! [NSObject : AnyObject])
        
        super.init(dictionary: dictionary)
        
    }
    
}
