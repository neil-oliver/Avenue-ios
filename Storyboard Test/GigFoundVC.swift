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
        selectedEvent = closeVenueEvents[0]
    }
    
    @IBAction func btnSelect(sender: AnyObject){
    
    }
    
    @IBAction func btnMenu(sender: AnyObject) {
        let menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as! MenuTBC
        menutbc.selectedIndex = 0
        let navigationController = UINavigationController(rootViewController: menutbc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    func whereWhen (){
        
        if closeVenueEvents.count != 0 {
            // nested if statement to work out where the user is and if there is an event listed. println() statements describe each condition of the if statement.
            if closeVenueEvents[0].distance <= 1 {
                print("The Nearest venue to you is \(closeVenueEvents[0].venue.displayName) and you are within 1000m", appendNewline: true)
                
                if dateComparison(closeVenueEvents[0].event.start.datetime as! String, endDateString: closeVenueEvents[0].event.end.datetime as! String) == 1 {
                    lblTitle.text = ("\(closeVenueEvents[0].venue.displayName) has the event \(closeVenueEvents[0].event.displayName) listed but is in the future")
                    btnSelect.hidden = false
                    
                } else if dateComparison(closeVenueEvents[0].event.start.datetime as! String, endDateString: closeVenueEvents[0].event.end.datetime as! String) == 0 {
                    lblTitle.text = ("The event \(closeVenueEvents[0].event.displayName) is currently happening at \(closeVenueEvents[0].venue.displayName)")
                    btnContinue.hidden = false
                    btnSelect.hidden = false
                }
                
                
            } else if closeVenueEvents[0].distance > 1 {
                print("The Nearest venue to you is \(closeVenueEvents[0].venue.displayName) and you are not within 1000m", appendNewline: true)
                
                if dateComparison(closeVenueEvents[0].event.start.datetime as! String, endDateString: closeVenueEvents[0].event.end.datetime as! String) == 1 {
                    lblTitle.text = ("\(closeVenueEvents[0].venue.displayName) has the event \(closeVenueEvents[0].event.displayName) listed but is in the future")
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
        self.whereWhen()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
