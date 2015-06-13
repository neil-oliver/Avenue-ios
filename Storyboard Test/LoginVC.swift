//
//  LoginVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, NSURLConnectionDelegate, UITextFieldDelegate {
    
    // variable to call the OneShotLocationManager class
    var manager: OneShotLocationManager?
    
    //variable to hold data from NSURLConnection request
    lazy var data = NSMutableData()
    
    //spinner for loading
    let spinner = UIActivityIndicatorView()

    

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    let client = BAAClient.sharedClient()
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func btnSignup(sender: AnyObject) {
        let signupvc:SignupVC = self.storyboard?.instantiateViewControllerWithIdentifier("SignupVC") as! SignupVC
        let navigationController = UINavigationController(rootViewController: signupvc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    @IBAction func btnLogin(sender: AnyObject) {
        //self.spinner.startAnimating()
        print("login button pushed")
        BAAUser.loginWithUsername(txtUsername.text, password:txtPassword.text, completion: { (success: Bool, error: NSError!) -> () in
            
            print("BAAUser login called")
            if (success) {
                
                print("successful log in")
                //move past login screen to either the main menu or the gig found screen.

                    let menutbc : MenuTBC = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as! MenuTBC
                    menutbc.selectedIndex = 0
                    let navigationController = UINavigationController(rootViewController: menutbc)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                
                
                
                
            } else {
                
                print("log in error \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Sign In Error", message:
                    "log in error \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            //self.spinner.stopAnimating()
        })
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPassword.delegate = self
        self.txtUsername.delegate = self
        //check to see if a user is already authenticated
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        
        if client.isAuthenticated() {
            
            print("Logged in")
            
        } else {
            
            print("Not logged in")
        }
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)        
        // automatically moves past the login screen if user is authenticated.
        if client.isAuthenticated(){

                let menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as! MenuTBC
                menutbc.selectedIndex = 0
                let navigationController = UINavigationController(rootViewController: menutbc)
                self.presentViewController(navigationController, animated: true, completion: nil)
            
        }
        
    }
    
}
