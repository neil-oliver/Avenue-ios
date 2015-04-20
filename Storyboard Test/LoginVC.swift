//
//  LoginVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController, NSURLConnectionDelegate {
    
    // variable to call the OneShotLocationManager class
    var manager: OneShotLocationManager?
    
    //variable to hold data from NSURLConnection request
    lazy var data = NSMutableData()
    
    var persistenceHelper: PersistenceHelper = PersistenceHelper()

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let client = BAAClient.sharedClient()
    
    @IBAction func btnSignup(sender: AnyObject) {
        var signupvc:SignupVC = self.storyboard?.instantiateViewControllerWithIdentifier("SignupVC") as SignupVC
        let navigationController = UINavigationController(rootViewController: signupvc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    @IBAction func btnLogin(sender: AnyObject) {
        
        
        BAAUser.loginWithUsername(txtUsername.text, password:txtPassword.text, { (success: Bool, error: NSError!) -> () in
            
            
            if (success) {
                
                println("successful log in")
                
                if closeEvents.count != 0 {
                    if closeEvents[0].locations.distance < 100 {
                        var gigfoundvc:GigFoundVC = self.storyboard?.instantiateViewControllerWithIdentifier("GigFoundVC") as GigFoundVC
                        let navigationController = UINavigationController(rootViewController: gigfoundvc)
                        self.presentViewController(navigationController, animated: true, completion: nil)
                    } else {
                        var menutbc : MenuTBC = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as MenuTBC
                        menutbc.selectedIndex = 0
                        let navigationController = UINavigationController(rootViewController: menutbc)
                        self.presentViewController(navigationController, animated: true, completion: nil)
                    }
                } else {
                    var menutbc : MenuTBC = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as MenuTBC
                    menutbc.selectedIndex = 0
                    let navigationController = UINavigationController(rootViewController: menutbc)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                }

                
                
            } else {
                
                println("log in error \(error.localizedDescription)")
                
            }
            
        })
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if client.isAuthenticated() {
            
            println("Logged in")
            
        } else {
            
            println("Not logged in")
        }
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if client.isAuthenticated(){
            if closeEvents.count != 0 {
                if closeEvents[0].locations.distance < 100 {
                    var gigfoundvc:GigFoundVC = storyboard?.instantiateViewControllerWithIdentifier("GigFoundVC") as GigFoundVC
                    let navigationController = UINavigationController(rootViewController: gigfoundvc)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                } else {
                    var menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as MenuTBC
                    menutbc.selectedIndex = 0
                    let navigationController = UINavigationController(rootViewController: menutbc)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                }
            } else {
                var menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as MenuTBC
                menutbc.selectedIndex = 0
                let navigationController = UINavigationController(rootViewController: menutbc)
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
        */
    }
    
}
