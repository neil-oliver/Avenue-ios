//
//  SettingsVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 17/02/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet var txtUsername: UITextField!
    
    @IBOutlet var txtFname: UITextField!
    
    @IBOutlet var txtSname: UITextField!
    
    @IBOutlet var txtEmail: UITextField!
    
    @IBAction func btnSave(sender: AnyObject) {
        
        BAAUser.loadCurrentUserWithCompletion({(object:AnyObject!, error: NSError!) -> () in
            
            if ((object) != nil) {
                let currentUser = object as! BAAUser
                currentUser.firstName = self.txtFname.text!
                currentUser.lastName = self.txtSname.text!
                currentUser.email = self.txtEmail.text!
                
                currentUser.updateWithCompletion({(object:AnyObject!, error: NSError!) -> () in
                  print("updated user: \(object)")
                })
            }
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        swtchOnlineSearch.on = OnlineSearch
        
        // Do any additional setup after loading the view.
        
        BAAUser.loadCurrentUserWithCompletion({(object:AnyObject!, error: NSError!) -> () in
        
            if ((object) != nil) {
                let currentUser = object as! BAAUser
                self.txtUsername.text = currentUser.username()
                self.txtFname.text = currentUser.firstName
                self.txtSname.text = currentUser.lastName
                self.txtEmail.text = currentUser.email
            }
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var swtchOnlineSearch: UISwitch!
    
    @IBAction func swtchOnlineSearch(sender: AnyObject) {
        OnlineSearch = swtchOnlineSearch.on
    }
    
}
