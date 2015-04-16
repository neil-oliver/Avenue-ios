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
    
    // variable to call the OneShotLocationManager class
    var manager: OneShotLocationManager?
    
    //variable to hold data from NSURLConnection request
    lazy var data = NSMutableData()
    
    //This is your tableView
    @IBOutlet var EventTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "The Archive"
        self.EventTable.reloadData()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.EventTable.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Events")
        request.returnsObjectsAsFaults = false;
        request.relationshipKeyPathsForPrefetching = ["locations"]
        request.predicate = NSPredicate(format: "event_end < %@ && event_name != ''", dateTime)
        self.results = context.executeFetchRequest(request, error: nil) as [Events]
        
    }
    
    func refresh(sender:AnyObject){
        println("refresh")
        sleep(1)
        self.EventTable.reloadData()
        self.refreshControl.endRefreshing()
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        EventTable.reloadData()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")
        
        //Assign the contents of our var "items" to the textLabel of each cell
        //cell.textLabel?.text = "test"
        cell.textLabel?.text = results[indexPath.row].event_name
        cell.detailTextLabel?.text = "Event Date: \(results[indexPath.row].event_start_date)"
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Create instance of DetailVC
        var archiveeventvc:ArchiveEventVC = storyboard?.instantiateViewControllerWithIdentifier("ArchiveEventVC") as ArchiveEventVC
        //Reference DetailVC's var "cellName" and assign it to DetailVC's var "items"
        //archiveeventvc.SelectedLocationID = locationMgr.locations[indexPath.row].LocationID
        //archiveeventvc.SelectedLocationName = locationMgr.locations[indexPath.row].LocationName
        //var SelectedLocationID: String = locationMgr.locations[indexPath.row].LocationID!
        //archiveeventvc.SelectedLocationIndex = indexPath.row
        //Programmatically push to associated VC (EventsVC)
        self.navigationController?.pushViewController(archiveeventvc, animated: true)
    }

}
