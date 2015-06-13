//
//  SignupVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 20/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import UIKit


class SignupVC: UIViewController {
    
    let spinner = UIActivityIndicatorView()
    
    @IBOutlet var txtUsername: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var txtConfirm: UITextField!
    
    @IBAction func btnCancel(sender: AnyObject) {
        
        let loginvc:LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        let navigationController = UINavigationController(rootViewController: loginvc)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    let client = BAAClient.sharedClient()

    
    @IBAction func btnSignup(sender: AnyObject) {
        
        if txtPassword.text == txtConfirm.text {
        
            spinner.startAnimating()
            
            client.createUserWithUsername(txtUsername.text, password:txtPassword.text, completion: { (success: Bool, error: NSError!) -> () in
                
                
                self.spinner.stopAnimating()
                
                
                
                if (success) {
                    
                    print("created")
                    
                    self.txtUsername.resignFirstResponder()
                    
                    self.txtPassword.resignFirstResponder()
                    

                        let menutbc : MenuTBC = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as! MenuTBC
                        menutbc.selectedIndex = 0
                        let navigationController = UINavigationController(rootViewController: menutbc)
                        self.presentViewController(navigationController, animated: true, completion: nil)
                    
                    
                    
                    
                } else {
                    
                    print(error.localizedDescription)
                    let alertController = UIAlertController(title: "Sign Up Error", message:
                        error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            })
            
        } else {
            
            let alertController = UIAlertController(title: "Sign Up Error", message:
                "Please retype your passwords", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.spinner.center = self.center
        //self.addSubview(self.spinner)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

