//
//  EventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import AVFoundation

class EventVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBAction func GridListSwitch(sender: AnyObject) {
    
    }
    
    @IBOutlet weak var inputToolbar: UIToolbar!
        
    @IBOutlet var txtComment: UITextField!
    
    @IBOutlet var cvEventGallery: UICollectionView!
    
    @IBOutlet var btnSend: UIBarButtonItem!
    
    var cellComment: [String] = []
    
    let spinner = UIActivityIndicatorView()
    
    var photoGallery: [UIImage] = []
    
    var eventGallery: [[AnyObject]] = []
    
    @IBAction func btnSend(sender: AnyObject) {
        sendComment(txtComment.text)
    }
    
    func sendComment(comment: String) {
        btnSend.enabled = false
        var newComment : BAAComment = BAAComment()
        newComment.comment = comment
        if newComment.comment != "" {
            newComment.saveObjectWithCompletion({(object:AnyObject!, error: NSError!) -> Void in
                if object != nil {
                    self.btnSend.enabled = true
                    println("Object: \(object)")
                    createBaasLink(object.objectId, selectedEvent!.event.objectId)
                    self.eventGallery.append([comment, UIImage(named: "white.jpg")!])
                    self.cvEventGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.eventGallery.count-1, inSection: 0)])
                    self.txtComment.text = ""
                    
                }
                if error != nil {
                    self.btnSend.enabled = true
                    println("Error: \(error)")
                    let alertController = UIAlertController(title: "Error", message:
                        "Message Send Error: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        } else {
            let alertController = UIAlertController(title: "Error", message:
                "Please enter a message before attempting to send", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtComment.endEditing(true)
        return false
    }
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var cvComments: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.txtComment.delegate = self
        lblTitle.text = selectedEvent?.event.displayName as? String
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        //getBaasCommentsAndFiles()
        //getBaasImages()
        getEventComments()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventGallery.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvEventGalleryCell", forIndexPath: indexPath) as! cvEventGalleryCell
        cell.backgroundColor = UIColor.blueColor()
        cell.imgEventGalleryPhoto.image = eventGallery[indexPath.row][1] as? UIImage

        cell.imgEventGalleryPhoto.contentMode = .ScaleAspectFill
        cell.CommentLabel.text = eventGallery[indexPath.row][0] as? String

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        var singleimagevc:SingleImageVC = storyboard?.instantiateViewControllerWithIdentifier("SingleImageVC") as! SingleImageVC
        singleimagevc.SingleImage = eventGallery[indexPath.row][1] as? UIImage
        singleimagevc.SingleComment = eventGallery[indexPath.row][0] as! String
        
        BAAUser.loadCurrentUserWithCompletion({(object:AnyObject!, error: NSError!) -> () in
            
            var currentUser = object as! BAAUser
            singleimagevc.User = currentUser.username()
            //Programmatically push to associated VC
            self.navigationController?.pushViewController(singleimagevc, animated: true)
        })
        
        
    }
    
    @IBAction func btnCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.allowsEditing = true
            imag.sourceType = UIImagePickerControllerSourceType.Camera;
            self.presentViewController(imag, animated: true, completion: nil)
            
        }
        
    }
    
    let insertIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        println("photo taken")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        var photo: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let metadata = info[UIImagePickerControllerMediaMetadata] as? NSDictionary
        var exif: NSDictionary = metadata?.objectForKey("{Exif}") as! NSDictionary
        
        if latValue != 0 && lonValue != 0 {
            exif.setValue(latValue, forKey: "Lat")
            exif.setValue(lonValue, forKey: "Lon")
        }else{
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
                    exif.setValue(latValue, forKey: "Lat")
                    exif.setValue(lonValue, forKey: "Lon")
                    
                    
                } else if var err = error {
                    println(err.localizedDescription)
                }
            }
        }
        
        var attachedExif: NSMutableDictionary = exif.mutableCopy() as! NSMutableDictionary
        spinner.startAnimating()
        var data = UIImageJPEGRepresentation(photo, 1.0)
        var file: BAAFile = BAAFile(data: data)
        file.contentType = "image/jpeg"
        file.attachedData = attachedExif
        file.uploadFileWithPermissions(nil, completion:{(uploadedFile: AnyObject!, error: NSError!) -> Void in
            if uploadedFile != nil {
                println("Object: \(uploadedFile)")
                createBaasLink(uploadedFile.fileId, selectedEvent!.event.objectId)
                //self.photoGallery.append(photo)
                //self.cellComment.append("")
                self.eventGallery.append(["", photo])
                self.cvEventGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.eventGallery.count-1, inSection: 0)])
                self.spinner.stopAnimating()
            }
            if error != nil {
                println("Upload Error: \(error)")
                self.spinner.stopAnimating()
                let alertController = UIAlertController(title: "Upload Error", message:
                    "Upload Error: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        })
    }
    
    func getEventComments(){
        
        //checks to see if the current location is set before starting connection. if its not it calls LocationManager
        if latValue != 0 && lonValue != 0 {
            println("getting linked comments")
            var path: NSString = "link"
            var params: NSDictionary = ["where": "in.event_id = \(selectedEvent!.event.event_id) and label=\"event_object\""]
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
                            self.cvEventGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.eventGallery.count - 1, inSection: 0)])
                        } else {
                            self.spinner.startAnimating()
                            var params = ["resize":"25%"]
                            eventAndComment.file.loadFileWithParameters( params as [NSObject : AnyObject], completion: {(data:NSData!, error:NSError!) -> () in
                                if data != nil {
                                    commentdata.image = UIImage(data: data)!
                                    self.downloadData.append(commentdata)
                                    self.eventGallery.insert([commentdata.comment, commentdata.image], atIndex: index)
                                    self.cvEventGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
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
    func getBaasCommentsAndFiles(){
        self.spinner.startAnimating()
        // Assumes BAAComment as a subclass of BAAObject
        var parameters: NSDictionary = [:]
        BAAComment.getObjectsWithParams(parameters as [NSObject : AnyObject], completion:{(comments:[AnyObject]!, error:NSError!) -> Void in
            println(comments)
            if comments != nil {
                println("recieved \(comments.count) comments")
                for single in comments {
                    var singlecomment: BAAComment = single as! BAAComment
                    println("comment written \(singlecomment.creationDate)")
                    var commentdata = downloadDataClass()
                    commentdata.comment = singlecomment.comment as String
                    commentdata.image = UIImage(named: "white.jpg")!
                    commentdata.date = singlecomment.creationDate as NSDate
                    self.downloadData.append(commentdata)
                    println("downloadData count from comments = \(self.downloadData.count)")
                    //self.downloadData.append([singlecomment.comment as String , UIImage(named: "white.jpg")! , singlecomment.creationDate])
                    if self.downloadData.count == comments.count {
                        
                        BAAFile.loadFilesAndDetailsWithCompletion({(files: [AnyObject]!, error: NSError!) -> () in
                            if files != nil {
                                println("recieved \(files.count) files")
                                for file in files {
                                    var image : BAAFile = file as! BAAFile // instance or subclass of BAAFile, previously saved on the server
                                    println("image taken \(image.creationDate)")
                                    image.loadFileWithCompletion({(data:NSData!, error:NSError!) -> () in
                                        var photodata = downloadDataClass()
                                        photodata.comment = ""
                                        photodata.image = UIImage(data: data)!
                                        photodata.date = singlecomment.creationDate as NSDate
                                        self.downloadData.append(photodata)
                                        //self.downloadData.append(["" , UIImage(data: data)! , image.creationDate])
                                        println("downloadData count from files = \(self.downloadData.count)")
                                        println("total data download count \((files.count + comments.count))")
                                        
                                        if self.downloadData.count == (files.count + comments.count) {
                                            println("sorting data")
                                            //sort the array and then update the collection
                                            sort(&self.downloadData){ $0.date > $1.date } //doent work yet
                                            for item in self.downloadData {
                                                self.eventGallery.append([item.comment, item.image])
                                                self.cvEventGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.eventGallery.count - 1, inSection: 0)])
                                                self.spinner.stopAnimating()
                                            }
                                            
                                        }

                                    })
                                    
                                }
                            }
                            
                        })
                    }
                }
            }
            if error != nil {
                println("Error: \(error)")
                self.spinner.stopAnimating()

            }
        })
        
    }
    */
    
    //// toolbar experimenting - close but not there yet
    /*
    
    var toolBar: UIToolbar!
    var textView: UITextView!
    var sendButton: UIButton!
    var rotating = false
    
    let messageFontSize: CGFloat = 17
    let toolBarMinHeight: CGFloat = 44
    let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)
    
    override var inputAccessoryView: UIView! {
       
        get {
            if toolBar == nil {
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))
                
                textView = InputTextView(frame: CGRectZero)
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                //        textView.placeholder = "Message"
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton.buttonWithType(.System) as! UIButton
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                sendButton.setTitle("Send", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: "sendAction", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(sendButton)
                
                // Auto Layout allows `sendButton` to change width, e.g., for localization.
                textView.setTranslatesAutoresizingMaskIntoConstraints(false)
                sendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Left, multiplier: 1, constant: 8))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: sendButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
            }
            return toolBar
        }

    }
    
    
    class InputTextView: UITextView {
        override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    
    func textViewDidChange(textView: UITextView) {
        sendButton.enabled = textView.hasText()
    }
    
    
    func sendAction() {
        textView.resignFirstResponder()
        textView.becomeFirstResponder()
        sendComment(textView.text)
        textView.text = nil
        sendButton.enabled = false
        view.endEditing(true)

    }
    */
}
