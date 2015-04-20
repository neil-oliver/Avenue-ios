//
//  Users.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 27/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import Foundation
import CoreData

@objc(Users)
class Users: NSManagedObject {

    @NSManaged var user_date_created: NSDate
    @NSManaged var user_email: NSString
    @NSManaged var user_id: NSNumber
    @NSManaged var user_logged_in: NSNumber
    @NSManaged var user_login: NSString
    @NSManaged var user_nicename: NSString
    @NSManaged var user_pass: NSString
    @NSManaged var user_registered: NSDate
    @NSManaged var user_role: NSString
    @NSManaged var user_status: NSNumber

}
