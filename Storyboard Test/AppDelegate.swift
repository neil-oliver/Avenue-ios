//
//  AppDelegate.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 20/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        BaasBox.setBaseURL("http://api.bethehype.co.uk", appCode: "1234567890")
        //BaasBox.setBaseURL("http://localhost:9000", appCode: "1234567890")
        
        
        BAAUser.loadCurrentUserWithCompletion({(object:AnyObject!, error: NSError!) -> () in
        
            if ((error) != nil) {
                
                //let loginvc:LoginVC = storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                //self.presentViewController(loginvc, animated: true, completion: nil)
                
            }
            
        })
        
        FetchData().getLocation(){(locationSet: Bool) in
            FetchData().getNewEvents(){(results: Bool) in
                FetchData().getBassVenuesEvents() {(getBassVenuesEventsResult: Bool) in
                    let alertController = UIAlertController(title: "Close Events", message:
                        "Events were found and saved to your device!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.window?.rootViewController?.presentedViewController?.presentViewController(alertController, animated: true, completion: nil)
                }
                FetchData().getVenuesWithLinks() {(getBassVenuesWithLinksResult: Bool) in
                }
            }
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:MM:ss.FFFZ"
        formattedDateTime = dateFormatter.stringFromDate(NSDate())
        
        return true
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
}

