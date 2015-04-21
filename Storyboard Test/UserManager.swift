//
//  UserManager.swift
//  TableViewTest
//
//  Original Code by Created by David Owens on 7/4/14.
//  Copyright (c) 2014 rhinoIO. All rights reserved.
//

import UIKit
import CoreData

var userMgr:UserManager = UserManager()

struct User{
    var UserID: Int? = 0
    var UserNiceName: String? = ""
    var UserLogin: String? = ""
    var UserPass: String? = ""
    var UserEmail: String? = ""
    var UserRole: String? = ""
    var UserLoggedIn: Bool? = false
    var UserStatus: Int? = 0
    var UserRegistered: NSDate? = NSDate()
    var dateTime: NSDate? = NSDate()

}

class UserManager: NSObject {
    
    var users = [User]()
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    var predicateString: String = ""
    var predicateVars: NSArray = []
    var existingUserID: Int = 0
    
    func getUsers(){
        
        var tempUsers:NSArray = persistenceHelper.list("Users", predicateString: predicateString, predicateVars: predicateVars)
        for res:AnyObject in tempUsers{


            
            users.append(User(UserID:res.valueForKey("user_id") as! Int!,
                UserNiceName:res.valueForKey("user_nicename") as! String!,
                UserLogin:res.valueForKey("user_login") as! String!,
                UserPass:res.valueForKey("user_pass") as! String!,
                UserEmail:res.valueForKey("user_email") as! String!,
                UserRole:res.valueForKey("user_role") as! String!,
                UserLoggedIn:res.valueForKey("user_loggin_in") as! Bool!,
                UserStatus:res.valueForKey("user_status") as! Int!,
                UserRegistered:res.valueForKey("user_registered") as! NSDate!,
                dateTime:res.valueForKey("user_date_created") as! NSDate!))
        }
        
    }
    
    
    
    func addUser(UserID: AnyObject?, UserNiceName: AnyObject?, UserLogin: AnyObject?, UserPass: AnyObject?, UserEmail: AnyObject?, UserRole: AnyObject?, UserLoggedIn: AnyObject?, UserStatus: AnyObject?, UserRegistered: AnyObject?, dateTime: AnyObject?){
        
        var dicUser = [String: AnyObject]()
        dicUser["user_id"] = UserID
        dicUser["user_nicename"] = UserNiceName
        dicUser["user_login"] = UserLogin
        dicUser["user_pass"] = UserPass
        dicUser["user_email"] = UserEmail
        dicUser["user_role"] = UserRole
        dicUser["user_logged_in"] = UserLoggedIn
        dicUser["user_status"] = UserStatus
        dicUser["user_registered"] = UserRegistered
        dicUser["user_date_created"] = dateTime
        
        println("dicUser: \(dicUser)")
        
        var UserExistCheck = persistenceHelper.list("Users", predicateString: "user_id = %@", predicateVars: [UserID as! Int])
        println("existing user: \(UserExistCheck)")
        if UserExistCheck.count == 0 {
            if(persistenceHelper.save("Users", parameters: dicUser)){
                println("User saved")
                
                // if errors then its probably here as this is untested
                users.append(User(UserID: UserID as! Int?, UserNiceName: UserNiceName as! String?, UserLogin: UserLogin as! String?, UserPass: UserPass as! String?, UserEmail: UserEmail as! String?, UserRole: UserRole as! String?, UserLoggedIn: UserLoggedIn as! Bool?, UserStatus: UserStatus as! Int?, UserRegistered: UserRegistered as! NSDate?, dateTime: dateTime as! NSDate?))
            }
        } else {
            
            existingUserID = UserExistCheck[0].valueForKey("user_id") as! Int
            println("User already in database. User ID: \(existingUserID)")
            
        }
    }
    
    func removeUser(index:Int){
        
        var value:String = String(users[index].UserID!)
        
        if(persistenceHelper.remove("Users", key: "user_id", value: value)){
            users.removeAtIndex(index)
        }
    }
    

}

