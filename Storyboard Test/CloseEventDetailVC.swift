//
//  CloseEventDetailVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class CloseEventDetailVC: UIViewController {
    
    //var seletedCloseEvent: Events?
    
    // create instance of our custom transition manager
    
    var startDate = ""
    var startTime = ""
    var eventTitle = ""
    var venueId = ""
    
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEventTitle: UILabel!
    @IBOutlet var lblVenueName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblEventTitle.text = eventTitle
        lblVenueName.text = venueId
        lblStartDate.text = startDate
        lblStartTime.text = startTime
        
        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // set transition delegate for our menu view controller
        let menu = segue.destinationViewController as! CloseEventSideBarVC
 
    }
    
    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
