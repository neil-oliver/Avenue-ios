//
//  venueEventsVC.swift
//  Avenue
//
//  Created by Neil Oliver on 25/06/2015.
//  Copyright © 2015 Neil Oliver. All rights reserved.
//


import UIKit

class venueEventsVC: UIViewController {
    
    var manager: OneShotLocationManager?
    var selectedVenueName: String!
    
    @IBAction func btnDismiss(sender: AnyObject) {
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    var venueEvents = [BAAEvent]()
    
    func onlyEvents(){
        for single in closeVenueEvents {
            print("selectedVenueName \(selectedVenueName)", terminator: "\n")
            print("close event name \(single.event.displayName)", terminator: "\n")
            if (single.venue.displayName as! String) == selectedVenueName! {
                venueEvents.append(single.event as BAAEvent)
                print("added", terminator: "\n")
             }
        }
    }
    
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
        onlyEvents()
        
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
        
        return venueEvents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")
        
        var bestGuess: String = ""
        if venueEvents[indexPath.row].start.is_estimate == true {
            bestGuess = "- Estimate Start Time"
        } else {
            
        }
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.textLabel?.text = venueEvents[indexPath.row].displayName as? String
        cell.detailTextLabel?.text = "Start Time: \(venueEvents[indexPath.row].start.time) \(bestGuess)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let closeeventdetailvc:CloseEventDetailVC = storyboard?.instantiateViewControllerWithIdentifier("CloseEventDetailVC") as! CloseEventDetailVC
        //Reference DetailVC's var "cellName" and assign it to DetailVC's var "items"
        closeeventdetailvc.eventTitle = venueEvents[indexPath.row].displayName as! String
        closeeventdetailvc.startDate = "Start Date: \(venueEvents[indexPath.row].start.date)"
        closeeventdetailvc.startTime = "Start Time: \(venueEvents[indexPath.row].start.time)"
        
        //Programmatically push to associated VC (EventsVC)
        self.navigationController?.pushViewController(closeeventdetailvc, animated: true)
    }
    
}


