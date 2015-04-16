//
//  ProfileVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreData
class ProfileVC: UIViewController {


    @IBAction func btnSettings(sender: AnyObject) {
        
    }
    
    @IBAction func btnLogOut(sender: AnyObject) {
        
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "user_logged_in = true")
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        if results.count != 0 {
            let usersManagedObject = results[0] as Users
            usersManagedObject.user_logged_in = false // you can now use dot syntax instead of setValue
            context.save(nil)
            
            var loginvc:LoginVC = storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as LoginVC
            self.presentViewController(loginvc, animated: true, completion: nil)
        }
    
    }
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUsername.text = loggedInUser?.user_login as String?
        lblEmail.text = loggedInUser?.user_email as String?
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
