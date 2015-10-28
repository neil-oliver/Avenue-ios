//
//  ArchiveVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class ArchiveVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // possibly delete var results = [Events]()

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
        getArchiveEvents()
        
    }
    
    func refresh(sender:AnyObject){
        print("refresh", terminator: "\n")
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
    
    func getArchiveEvents(){
        
            let path: NSString = "link"
            let params: NSDictionary = ["where": "in.end.datetime < date('\(formattedDateTime)') and label=\"event_object\""]
            let c = BAAClient.sharedClient()
            
            c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                
                if success != nil {
                    let data: NSDictionary = success as! NSDictionary
                    let dataArray: [AnyObject] = data["data"] as! [AnyObject]
                    ArchiveEvents = []
                    for item in dataArray {
                        let eventAndComment = BAALinkedEventComments(dictionary: item as! [NSObject : AnyObject])
                        ArchiveEvents.append(eventAndComment)
                    }
                    
                    self.ArchiveTable.reloadData()
                }
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    print(failure, terminator: "\n")
                    
            })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ArchiveEvents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.textLabel?.text = ArchiveEvents[indexPath.row].event.displayName as? String
        cell.detailTextLabel?.text = "Start Time: \(ArchiveEvents[indexPath.row].event.start.time)"

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Create instance of DetailVC
        let archiveeventvc:ArchiveEventVC = storyboard?.instantiateViewControllerWithIdentifier("ArchiveEventVC") as! ArchiveEventVC
        archiveeventvc.selectedArchive = ArchiveEvents[indexPath.row]
        archiveeventvc.eventTitle = (ArchiveEvents[indexPath.row].event.displayName as? String)!
        //Programmatically push to associated VC (EventsVC)
        self.navigationController?.pushViewController(archiveeventvc, animated: true)
    }

}
