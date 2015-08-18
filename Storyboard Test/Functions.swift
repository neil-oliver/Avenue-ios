//
//  Functions.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 02/12/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreLocation
import CoreImage
import Foundation

    
    var manager: OneShotLocationManager?

    infix operator < {}

    /*
    func < (let left:NSDate, let right: NSDate) -> Bool {
        var result:NSComparisonResult = left.compare(right)
        var isEarlier = false
        if (result == NSComparisonResult.OrderedAscending) {
            isEarlier = true
        }
        return isEarlier
    }
    */

    public func <(a: NSDate, b: NSDate) -> Bool {
        return a.compare(b) == NSComparisonResult.OrderedAscending
    }

    public func ==(a: NSDate, b: NSDate) -> Bool {
        return a.compare(b) == NSComparisonResult.OrderedSame
    }

    extension NSDate: Comparable { }


func dateComparison(startDateString: String, endDateString: String ) ->Int {
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let startDate = dateFormatter.dateFromString(startDateString)!
        print(startDate, appendNewline: true)
    
        var startResult: Int!
        var endResult: Int!
        var returnResult: Int!
        
        if closeVenueEvents.count != 0 {
            
            //variable for current time
            let currentDateTime = NSDate()
            //time comparison outputs an NSCompareResult object
            let startDateComparisonResult : NSComparisonResult = currentDateTime.compare(startDate)
            
            //uses NSCompareResult to assign a value to date to dateComparison variable. 1 = future, 0 = exact time to second, -1 = past
            if startDateComparisonResult == NSComparisonResult.OrderedAscending {
                // Current date is smaller than start date. (gig is in the future)
                startResult = 1
                print("startResult: \(startResult)", appendNewline: true)
                
            } else if startDateComparisonResult == NSComparisonResult.OrderedDescending {
                // Current date is greater than start date. (gig has started or gig is in the past)
                startResult = -1
                print("startResult: \(startResult)", appendNewline: true)

            } else if startDateComparisonResult == NSComparisonResult.OrderedSame {
                // Current date and end date are same.
                startResult = 0
                print("startResult: \(startResult)", appendNewline: true)

            }
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            let endDate = dateFormatter.dateFromString(endDateString)!
            print(endDate, appendNewline: true)
            
            //no end date currently stored so using midnight of the day of the gig
            let endDateComparisonResult : NSComparisonResult = currentDateTime.compare(endDate)
            
            if endDateComparisonResult == NSComparisonResult.OrderedAscending {
                // Current date is smaller than end date. (gig is in the future or has not finished yet)
                endResult = 1
                print("endResult: \(endResult)", appendNewline: true)
            } else if endDateComparisonResult == NSComparisonResult.OrderedDescending {
                // Current date is greater than end date. (gig is in the past)
                endResult = -1
                print("endResult: \(endResult)", appendNewline: true)

            } else if endDateComparisonResult == NSComparisonResult.OrderedSame {
                // Current date and end date are same.
                endResult = 0
                print("endResult: \(endResult)", appendNewline: true)

            }
            
            
            if startResult <= 0 && endResult == 1 {
                //gig is happening now
                
                returnResult = 0
                print("returnResult: \(returnResult)", appendNewline: true)
                
            } else if startResult == 1 {
                //gig is in the future
                
                returnResult = 1
                print("returnResult: \(returnResult)", appendNewline: true)
                
            } else if endResult <= 0 {
                //gig in the past
                
                returnResult = -1
                print("returnResult: \(returnResult)", appendNewline: true)
            }
            

        }
        
        return returnResult
    }

func createBaasLink(inLink: String, outLink: String){

    let path: NSString = "link/\(inLink)/event_object/\(outLink)"
    let params: NSDictionary = ["" : ""]
    let c = BAAClient.sharedClient()
    
    c.postPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
    
        print(success, appendNewline: true)
        
        }, failure:{(failure: NSError!) -> Void in
            
            print(failure, appendNewline: true)
    })
    
    
    //return (Success, Error)
}

func checkLocationServices(delegate: UIViewController) {
    
    
    if CLLocationManager.locationServicesEnabled() == false {
        print("location services check", appendNewline: true)
        
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            print("iOS >= 8.0", appendNewline: true)
            let alertController = UIAlertController(title: "This app does not have access to Location service", message:
                "You can enable access in Settings->Privacy->Location->Location Services", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            //Direct user to settings - not currently working
            /*
            alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default,handler: { (alertAction) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(fileURLWithPath: UIApplicationOpenSettingsURLString)!)
                println("Open Settings")
            }))
            */
            delegate.presentViewController(alertController, animated: true, completion: nil)
            
            
        case .OrderedAscending:
            print("iOS < 8.0", appendNewline: true)
            let alertController = UIAlertController(title: "This app does not have access to Location service", message:
                "You can enable access in Settings->Privacy->Location->Location Services", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            delegate.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
}





