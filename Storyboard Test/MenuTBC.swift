//
//  MenuTBC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 24/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class MenuTBC: UITabBarController {


    @IBOutlet var btnGigOn: UIButton!
    @IBAction func btnGigOn(sender: AnyObject) {
        let gigfoundvc:GigFoundVC = storyboard?.instantiateViewControllerWithIdentifier("GigFoundVC") as! GigFoundVC
        let navigationController = UINavigationController(rootViewController: gigfoundvc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if gigFound == false {
            btnGigOn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        } else {
            btnGigOn.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        }
        
    }

}
