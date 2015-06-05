//
//  ProfileVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreData
class ProfileVC: UIViewController {


    @IBAction func btnSettings(sender: AnyObject) {
        
    }
    
    @IBOutlet var cvProfileGallery: UICollectionView!

    @IBAction func btnLogOut(sender: AnyObject) {
        
        BAAUser.logoutWithCompletion( {(success: Bool, error: NSError!) -> () in
            
            if (success) {
                var loginvc:LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                self.presentViewController(loginvc, animated: true, completion: nil)
            }else {
                
                println("log out error \(error.localizedDescription)")
                
            }
            
        })
        
        
    }
    
    var eventGallery: [[AnyObject]] = []
    let spinner = UIActivityIndicatorView()

    
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        BAAUser.loadCurrentUserWithCompletion({(object:AnyObject!, error: NSError!) -> () in
            
            var currentUser = object as! BAAUser
            self.lblUsername.text = currentUser.username()
            self.username = currentUser.username()
            self.getEventComments()
            })
        
        FetchData().getCommentsTest() //testing permissions
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func viewDidAppear() {
        cvProfileGallery.reloadData()
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventGallery.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvProfileCell", forIndexPath: indexPath) as! cvProfileCell
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
        BAAUser.loadUserDetails(eventGallery[indexPath.row][2] as! String, completion:{(object:AnyObject!, error: NSError!) -> () in
            
            var currentUser = object as! BAAUser
            singleimagevc.User = currentUser.username()
            //Programmatically push to associated VC
            self.navigationController?.pushViewController(singleimagevc, animated: true)
        })
        
    }
    
    
    let insertIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    func getEventComments(){
        
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            println("getting linked comments")
            var path: NSString = "link"
            var params: NSDictionary = ["where": "_author = \"\(self.username)\" and label=\"event_object\""]
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
                            commentdata.author = eventAndComment.comment.author
                        } else {
                            commentdata.comment = ""
                        }
                        if eventAndComment.file == nil {
                            commentdata.image = UIImage(named: "white.jpg")!
                            self.downloadData.append(commentdata)
                            self.eventGallery.append([commentdata.comment, commentdata.image, commentdata.author])
                            self.cvProfileGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.eventGallery.count - 1, inSection: 0)])
                        } else {
                            self.spinner.startAnimating()
                            var params = ["resize":"25%"]
                            eventAndComment.file.loadFileWithParameters( params as [NSObject : AnyObject], completion: {(data:NSData!, error:NSError!) -> () in
                                if data != nil {
                                    commentdata.author = eventAndComment.file.author
                                    commentdata.image = UIImage(data: data)!
                                    self.downloadData.append(commentdata)
                                    self.eventGallery.insert([commentdata.comment, commentdata.image, commentdata.author], atIndex: index)
                                    self.cvProfileGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
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
        var author = String()
    }
    
    var downloadData: [downloadDataClass] = []
    
}
