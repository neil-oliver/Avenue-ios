//
//  CloseEventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreData

class CloseEventVC: UIViewController {
    
    var manager: OneShotLocationManager?
    
    //variable for refreshing table data
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var EventTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.EventTable.addSubview(refreshControl)
        getBassEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject){
        println("refresh")
        getBassEvents()
        
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
    
    func getBassEvents(){
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            
            // Assumes BAAEvent as a subclass of BAAObject
            var parameters: NSDictionary = ["where" : "start.time > date('2015-05-08T07:33:51.000+0000')"]
            //var parameters: NSDictionary = ["":""]
            BAAEvent.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(events:[AnyObject]!, error:NSError!) -> Void in
                if events != nil {
                    CloseEvents = events as! [BAAEvent]
                    self.EventTable.reloadData()
                }
                if error != nil {
                    println("Error: \(error)")
                }
            })
            
        } else {
            
            manager = OneShotLocationManager()
            manager!.fetchWithCompletion {location, error in
                
                // fetch location or an error
                if var loc = location {
                    println(location)
                    //assigns values to variables for current latitude and logitude
                    latValue = loc.coordinate.latitude
                    lonValue = loc.coordinate.longitude
                    
                    //assigns a location object to variable
                    locationObj = loc
                    
                    // Assumes BAAEvent as a subclass of BAAObject
                    var parameters: NSDictionary = ["where" : "start.time > date('2015-05-08T07:33:51.000+0000')"]
                    //var parameters: NSDictionary = ["":""]
                    BAAEvent.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(events:[AnyObject]!, error:NSError!) -> Void in
                        if events != nil {
                            CloseEvents = events as! [BAAEvent]
                            self.EventTable.reloadData()
                        }
                        if error != nil {
                            println("Error: \(error)")
                        }
                    })
                    
                    
                    
                } else if var err = error {
                    println(err.localizedDescription)
                    let alertController = UIAlertController(title: "Failed to find location", message:
                        "Location error \(err.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                }
                self.manager = nil
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CloseEvents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.textLabel?.text = CloseEvents[indexPath.row].displayName as? String
        cell.detailTextLabel?.text = "Start Time: \(CloseEvents[indexPath.row].start.time)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var closeeventdetailvc:CloseEventDetailVC = storyboard?.instantiateViewControllerWithIdentifier("CloseEventDetailVC") as! CloseEventDetailVC
        //Reference DetailVC's var "cellName" and assign it to DetailVC's var "items"
        closeeventdetailvc.eventTitle = CloseEvents[indexPath.row].displayName as! String
        closeeventdetailvc.startDate = "Start Date: \(CloseEvents[indexPath.row].start.date)"
        closeeventdetailvc.startTime = "Start Time: \(CloseEvents[indexPath.row].start.time)"
        closeeventdetailvc.venueId = "Venue ID: \(CloseEvents[indexPath.row].venue_id)"
        
        //Programmatically push to associated VC (EventsVC)
        self.navigationController?.pushViewController(closeeventdetailvc, animated: true)
    }

}

