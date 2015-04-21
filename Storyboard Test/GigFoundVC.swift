//
//  GigFoundVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class GigFoundVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet var btnContinue: UIButton!
    @IBOutlet var btnSelect: UIButton!
    @IBAction func btnContinue(sender: AnyObject) {
        selectedEvent = closeEvents[0]
    }
    
    @IBAction func btnSelect(sender: AnyObject){
    
    }
    
    @IBAction func btnMenu(sender: AnyObject) {
        var menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as! MenuTBC
        menutbc.selectedIndex = 0
        let navigationController = UINavigationController(rootViewController: menutbc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func WhereWhen(){
        if closeEvents.count != 0 {
            // nested if statement to work out where the user is and if there is an event listed. println() statements describe each condition of the if statement.
            if closeEvents[0].locations.distance <= 100 {
                println("The Nearest venue to you is \(closeEvents[0].locations.location_name) and you are within 100m")
                
                if closeEvents[0].start_date_comparison_result >= 0 {
                    lblTitle.text = ("\(closeEvents[0].locations.location_name) has the event \(closeEvents[0].event_name) listed but is in the future")
                    btnSelect.hidden = false
                } else if closeEvents[0].start_date_comparison_result <= 0 && closeEvents[0].end_date_comparison_result == 1 {
                    lblTitle.text = ("The event \(closeEvents[0].event_name) is currently happening at \(closeEvents[0].locations.location_name)")
                    btnContinue.hidden = false
                    btnSelect.hidden = false
                }
                
                
            } else if closeEvents[0].locations.distance > 100 {
                println("The Nearest venue to you is \(closeEvents[0].locations.location_name) and you are not within 100m")
                
                if closeEvents[0].start_date_comparison_result >= 0 {
                    lblTitle.text = ("\(closeEvents[0].locations.location_name) has the event \(closeEvents[0].event_name) listed but is in the future")
                    btnSelect.hidden = false
                }
            }
            
            gigFound = true
            
        } else {
            lblTitle.text = "No gigs Found"
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinue.hidden = true
        btnSelect.hidden = true
        self.WhereWhen()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
