//
//  CloseEventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class CloseEventVC: UIViewController {
    
    var manager: OneShotLocationManager?
    
    //variable for refreshing table data
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var EventTable: UITableView!
    
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.spinner.center = self.EventTable.center
        self.spinner.color = UIColor.blackColor()
        self.EventTable.addSubview(self.spinner)
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.EventTable.addSubview(refreshControl)
        checkLocationServices(self)
        FetchData().getBassVenuesEvents() {(getBassVenuesEventsResult: Bool) in
            self.EventTable.reloadData()
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject){
        print("refresh", terminator: "\n")
        //FetchData().getBassVenuesEvents()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.EventTable.reloadData()
        })
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.EventTable.reloadData()
        })
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return closeVenueEvents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")
        
        var bestGuess: String = ""
        if closeVenueEvents[indexPath.row].event.start.is_estimate == true {
            bestGuess = "- Estimate Start Time"
        } else {
            
        }
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.textLabel?.text = closeVenueEvents[indexPath.row].event.displayName as? String
        cell.detailTextLabel?.text = "Start Time: \(closeVenueEvents[indexPath.row].event.start.time) \(bestGuess)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let closeeventdetailvc:CloseEventDetailVC = storyboard?.instantiateViewControllerWithIdentifier("CloseEventDetailVC") as! CloseEventDetailVC
        //Reference DetailVC's var "cellName" and assign it to DetailVC's var "items"
        closeeventdetailvc.eventTitle = closeVenueEvents[indexPath.row].event.displayName as! String
        closeeventdetailvc.startDate = "Start Date: \(closeVenueEvents[indexPath.row].event.start.date)"
        closeeventdetailvc.startTime = "Start Time: \(closeVenueEvents[indexPath.row].event.start.time)"
        closeeventdetailvc.venueId = "Venue Name: \(closeVenueEvents[indexPath.row].venue.displayName)"
        
        //Programmatically push to associated VC (EventsVC)
        self.navigationController?.pushViewController(closeeventdetailvc, animated: true)
    }

}

