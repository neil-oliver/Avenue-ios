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
    let transitionManager = MenuTransitionManager()
    
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEventTitle: UILabel!
    @IBOutlet var lblVenueName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEventTitle.text = seletedCloseEvent?.event_name
        lblVenueName.text = "Venue: \(seletedCloseEvent?.locations.location_name as String)"
        lblStartDate.text = "Start Date: \(seletedCloseEvent?.event_start_date as String)"
        lblStartTime.text = "Start Time: \(seletedCloseEvent?.event_start_time as String)"
        // Do any additional setup after loading the view.
        self.transitionManager.sourceViewController = self
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // set transition delegate for our menu view controller
        let menu = segue.destinationViewController as CloseEventSideBarVC
        menu.transitioningDelegate = self.transitionManager
        self.transitionManager.menuViewController = menu
        
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