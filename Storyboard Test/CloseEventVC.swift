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
        getBassVenuesEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject){
        println("refresh")
        getBassVenuesEvents()
        
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

    
    func getBassVenuesEvents(){
        
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            println("getting venues and events")
            var path: NSString = "link"
            var params: NSDictionary = ["where" : "distance(out.lat,out.lng,\(latValue),\(lonValue)) < 10 and in.start.datetime > date('\(formattedDateTime)') and label=\"venue_event\""]
            var c = BAAClient.sharedClient()
            
            c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                
                var data: NSDictionary = success as! NSDictionary
                var dataArray: [AnyObject] = data["data"] as! [AnyObject]
                for item in dataArray {
                    
                    var venueAndEvent = BAALinkedVenueEvents(dictionary: item as! [NSObject : AnyObject])
                    closeVenueEvents.append(venueAndEvent)
                    println(venueAndEvent.venue.displayName)
                    println(venueAndEvent.event.displayName)
                    self.EventTable.reloadData()
                }
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    println(failure)
                    
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return closeVenueEvents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.textLabel?.text = closeVenueEvents[indexPath.row].event.displayName as? String
        cell.detailTextLabel?.text = "Start Time: \(closeVenueEvents[indexPath.row].event.start.time)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var closeeventdetailvc:CloseEventDetailVC = storyboard?.instantiateViewControllerWithIdentifier("CloseEventDetailVC") as! CloseEventDetailVC
        //Reference DetailVC's var "cellName" and assign it to DetailVC's var "items"
        closeeventdetailvc.eventTitle = closeVenueEvents[indexPath.row].event.displayName as! String
        closeeventdetailvc.startDate = "Start Date: \(closeVenueEvents[indexPath.row].event.start.date)"
        closeeventdetailvc.startTime = "Start Time: \(closeVenueEvents[indexPath.row].event.start.time)"
        closeeventdetailvc.venueId = "Venue Name: \(closeVenueEvents[indexPath.row].venue.displayName)"
        
        //Programmatically push to associated VC (EventsVC)
        self.navigationController?.pushViewController(closeeventdetailvc, animated: true)
    }

}

