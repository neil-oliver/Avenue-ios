//
//  ArchiveEventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class ArchiveEventVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var selectedArchive: BAALinkedEventComments!
    
    @IBOutlet weak var cvComments: UICollectionView!

    lazy var data = NSMutableData()
    
    let spinner = UIActivityIndicatorView()
    
    var eventGallery: [[AnyObject]] = []
    
    @IBOutlet var cvArchiveGallery: UICollectionView!
    
    //variable for refreshing table data
    var refreshControl:UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEventComments()
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
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        var singleimagevc:SingleImageVC = storyboard?.instantiateViewControllerWithIdentifier("SingleImageVC") as! SingleImageVC
        singleimagevc.SingleImage = eventGallery[indexPath.row][1] as? UIImage
        singleimagevc.SingleComment = eventGallery[indexPath.row][0] as! String
        //Programmatically push to associated VC
        self.navigationController?.pushViewController(singleimagevc, animated: true)
        
    }
    
    
    let insertIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    func getEventComments(){
        
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            println("getting linked comments")
            var path: NSString = "link"
            var params: NSDictionary = ["where": "in.event_id = \(selectedArchive!.event.event_id) and label=\"event_object\""]
            var c = BAAClient.sharedClient()
            
            c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                
                if success != nil {
                    println(success)
                    var data: NSDictionary = success as! NSDictionary
                    var dataArray: [AnyObject] = data["data"] as! [AnyObject]
                    
                    
                    for (index, item) in enumerate(dataArray) {
                        
                        var eventAndComment = BAALinkedEventComments(dictionary: item as! [NSObject : AnyObject])
                        eventComments.append(eventAndComment)
                        var commentdata = downloadDataClass()
                        if eventAndComment.comment != nil {
                            commentdata.comment = eventAndComment.comment.comment as String
                        } else {
                            commentdata.comment = ""
                        }
                        if eventAndComment.file == nil {
                            commentdata.image = UIImage(named: "white.jpg")!
                            self.downloadData.append(commentdata)
                            self.eventGallery.append([commentdata.comment, commentdata.image])
                            self.cvArchiveGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.eventGallery.count - 1, inSection: 0)])
                        } else {
                            self.spinner.startAnimating()
                            var params = ["resize":"25%"]
                            eventAndComment.file.loadFileWithParameters( params as [NSObject : AnyObject], completion: {(data:NSData!, error:NSError!) -> () in
                                if data != nil {
                                    commentdata.image = UIImage(data: data)!
                                    self.downloadData.append(commentdata)
                                    self.eventGallery.insert([commentdata.comment, commentdata.image], atIndex: index)
                                    self.cvArchiveGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
                                    self.spinner.stopAnimating()
                                }
                            })
                        }
                        commentdata.date = eventAndComment.creationDate as NSDate
                    }
                    
                }
                
                }, failure:{(failure: NSError!) -> Void in
                    
                    println(failure)
                    
            })
        }
    }
    
    
    class downloadDataClass {
        var comment = String()
        var image = UIImage()
        var date = NSDate()
    }
    
    var downloadData: [downloadDataClass] = []
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
