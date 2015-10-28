//
//  ArchiveEventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
//import Spring

class ArchiveEventVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var selectedArchive: BAALinkedEventComments!
    
    @IBOutlet weak var cvComments: UICollectionView!
    
    @IBOutlet var lblEventTitle: UILabel!
    
    var eventTitle: String = ""

    lazy var data = NSMutableData()
    
    let spinner = UIActivityIndicatorView()
    
    var eventGallery: [[AnyObject]] = []
    
    @IBOutlet var cvArchiveGallery: UICollectionView!
    
    //variable for refreshing table data
    var refreshControl:UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEventComments()
        lblEventTitle.text = eventTitle
        UIApplication.sharedApplication().sendAction("minimizeView:", to: nil, from: self, forEvent: nil)

        // Do any additional setup after loading the view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewDidAppear() {
        cvArchiveGallery.reloadData()
    }
    

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventGallery.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvArchiveEventCell", forIndexPath: indexPath) as! cvArchiveEventCell
        cell.backgroundColor = UIColor.blueColor()
        cell.imgBox.image = eventGallery[indexPath.row][1] as? UIImage
        cell.imgBox.contentMode = .ScaleAspectFill
        cell.CommentLabel.text = eventGallery[indexPath.row][0] as? String
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //var cell = collectionView.cellForItemAtIndexPath(indexPath)
        let singleimagevc:SingleImageVC = storyboard?.instantiateViewControllerWithIdentifier("SingleImageVC") as! SingleImageVC
        singleimagevc.SingleImage = eventGallery[indexPath.row][1] as? UIImage
        singleimagevc.SingleComment = eventGallery[indexPath.row][0] as! String
        BAAUser.loadUserDetails(eventGallery[indexPath.row][2] as! String, completion:{(object:AnyObject!, error: NSError!) -> () in
            
            let currentUser = object as! BAAUser
            singleimagevc.User = currentUser.username()
            //Programmatically push to associated VC
            self.navigationController?.pushViewController(singleimagevc, animated: true)
        })
        
    }
    
    
    let insertIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    func getEventComments(){
        
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            print("getting linked comments", terminator: "\n")
            let path: NSString = "link"
            let params: NSDictionary = ["where": "in.event_id = \(selectedArchive!.event.event_id) and label=\"event_object\""]
            let c = BAAClient.sharedClient()
            
            c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                
                if success != nil {
                    print(success, terminator: "\n")
                    let data: NSDictionary = success as! NSDictionary
                    let dataArray: [AnyObject] = data["data"] as! [AnyObject]
                    
                    
                    for (index, item) in dataArray.enumerate() {
                        
                        let eventAndComment = BAALinkedEventComments(dictionary: item as! [NSObject : AnyObject])
                        eventComments.append(eventAndComment)
                        let commentdata = downloadDataClass()
                        if eventAndComment.comment != nil {
                            commentdata.comment = eventAndComment.comment.comment as String
                            commentdata.author = eventAndComment.comment.author
                        } else {
                            commentdata.comment = ""
                        }
                        if eventAndComment.file == nil {
                            commentdata.image = UIImage(named: "white.jpg")!
                            self.downloadData.append(commentdata)
                            self.eventGallery.append([commentdata.comment, commentdata.image, commentdata.author])
                            self.cvArchiveGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.eventGallery.count - 1, inSection: 0)])
                        } else {
                            self.spinner.startAnimating()
                            let params = ["resize":"25%"]
                            eventAndComment.file.loadFileWithParameters( params as [NSObject : AnyObject], completion: {(data:NSData!, error:NSError!) -> () in
                                if data != nil {
                                    commentdata.author = eventAndComment.file.author
                                    commentdata.image = UIImage(data: data)!
                                    self.downloadData.append(commentdata)
                                    self.eventGallery.insert([commentdata.comment, commentdata.image, commentdata.author], atIndex: index)
                                    self.cvArchiveGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
                                    self.spinner.stopAnimating()
                                }
                            })
                        }
                        //commentdata.date = eventAndComment.creationDate as NSDate
                    }
                    
                }
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    print(failure, terminator: "\n")
                    
            })
        }
    }
    
    
    class downloadDataClass {
        var comment = String()
        var image = UIImage()
        var date = NSDate()
        var author = String()
    }
    
    var downloadData: [downloadDataClass] = []
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if let ArchiveEventSideBarVC = segue.destinationViewController as? ArchiveEventSideBarVC {
            //ArchiveEventSideBarVC.data = ballView
        //}
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
