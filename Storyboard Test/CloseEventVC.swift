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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject){
        println("refresh")
        sleep(1)
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
        
        return closeEvents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.textLabel?.text = closeEvents[indexPath.row].event_name
        cell.detailTextLabel?.text = "Distance from you: \(closeEvents[indexPath.row].locations.distance)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var closeeventdetailvc:CloseEventDetailVC = storyboard?.instantiateViewControllerWithIdentifier("CloseEventDetailVC") as CloseEventDetailVC
        //Reference DetailVC's var "cellName" and assign it to DetailVC's var "items"
        seletedCloseEvent = closeEvents[indexPath.row]

        //Programmatically push to associated VC (EventsVC)
        self.navigationController?.pushViewController(closeeventdetailvc, animated: true)
    }

}

