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
        
        BAAUser.logoutWithCompletion( {(success: Bool, error: NSError!) -> () in
            
            if (success) {
                var loginvc:LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                self.presentViewController(loginvc, animated: true, completion: nil)
            }else {
                
                println("log out error \(error.localizedDescription)")
                
            }
            
        })
        
        
    }
    
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        BAAUser.loadCurrentUserWithCompletion({(object:AnyObject!, error: NSError!) -> () in
            
            var currentUser = object as! BAAUser
            self.lblUsername.text = currentUser.username()            
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
