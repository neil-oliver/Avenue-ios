//
//  ArchiveVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreData

class ArchiveVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var results = [Events]()

    //variable for refreshing table data
    var refreshControl:UIRefreshControl!
    
    var manager: OneShotLocationManager?

    //This is your tableView
    @IBOutlet var ArchiveTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "The Archive"
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.ArchiveTable.addSubview(refreshControl)
        getBassEvents()
        
    }
    
    func refresh(sender:AnyObject){
        println("refresh")
        sleep(1)
        self.ArchiveTable.reloadData()
        self.refreshControl.endRefreshing()
        
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        ArchiveTable.reloadData()
        
    }
    
    func getBassEvents(){
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            
            // Assumes BAAEvent as a subclass of BAAObject
            var parameters: NSDictionary = ["where" : "start.datetime < date('\(formattedDateTime)')"]
            //var parameters: NSDictionary = ["":""]
            BAAEvent.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(events:[AnyObject]!, error:NSError!) -> Void in
                if events != nil {
                    ArchiveEvents = events as! [BAAEvent]
                    self.ArchiveTable.reloadData()
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
                    var parameters: NSDictionary = ["where" : "start.datetime < date('\(formattedDateTime)')"]
                    //var parameters: NSDictionary = ["":""]
                    BAAEvent.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(events:[AnyObject]!, error:NSError!) -> Void in
                        if events != nil {
                            ArchiveEvents = events as! [BAAEvent]
                            self.ArchiveTable.reloadData()
                            
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
        
        return ArchiveEvents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.textLabel?.text = ArchiveEvents[indexPath.row].displayName as? String
        cell.detailTextLabel?.text = "Start Time: \(ArchiveEvents[indexPath.row].start.time)"

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Create instance of DetailVC
        var archiveeventvc:ArchiveEventVC = storyboard?.instantiateViewControllerWithIdentifier("ArchiveEventVC") as! ArchiveEventVC
        //Reference DetailVC's var "cellName" and assign it to DetailVC's var "items"
        //archiveeventvc.SelectedLocationID = locationMgr.locations[indexPath.row].LocationID
        //archiveeventvc.SelectedLocationName = locationMgr.locations[indexPath.row].LocationName
        //var SelectedLocationID: String = locationMgr.locations[indexPath.row].LocationID!
        //archiveeventvc.SelectedLocationIndex = indexPath.row
        //Programmatically push to associated VC (EventsVC)
        self.navigationController?.pushViewController(archiveeventvc, animated: true)
    }

}
