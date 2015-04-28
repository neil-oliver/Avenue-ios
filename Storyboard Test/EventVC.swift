//
//  EventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import AVFoundation

class EventVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBAction func GridListSwitch(sender: AnyObject) {
    }
    
    @IBOutlet var txtComment: UITextField!
    
    @IBOutlet var cvEventGallery: UICollectionView!
    
    @IBOutlet var btnSend: UIBarButtonItem!
    
    var cellComment: [String] = []
    
    let spinner = UIActivityIndicatorView()
    
    var photoGallery: [UIImage] = []
    
    @IBAction func btnSend(sender: AnyObject) {
        btnSend.enabled = false
        var newComment : BAAComment = BAAComment()
        newComment.comment = txtComment.text
        if newComment.comment != "" {
            newComment.saveObjectWithCompletion({(object:AnyObject!, error: NSError!) -> Void in
                if object != nil {
                    self.btnSend.enabled = true
                    println("Object: \(object)")
                    self.cellComment.append(self.txtComment.text)
                    self.photoGallery.append(UIImage(named: "white.jpg")!)
                    self.cvEventGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.photoGallery.count-1, inSection: 0)])
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
        lblTitle.text = selectedEvent?.event_name as? String
        self.navigationController!.toolbarHidden = false
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)

    }

    /* attempting to stick toolbar to keyboard
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override var inputAccessoryView: UIView! {
    return self.navigationController?.toolbar
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGallery.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvEventGalleryCell", forIndexPath: indexPath) as! cvEventGalleryCell
        cell.backgroundColor = UIColor.blueColor()
        cell.imgEventGalleryPhoto.image = photoGallery[indexPath.row]
        cell.imgEventGalleryPhoto.contentMode = .ScaleAspectFill
        cell.CommentLabel.text = cellComment[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        var singleimagevc:SingleImageVC = storyboard?.instantiateViewControllerWithIdentifier("SingleImageVC") as! SingleImageVC
        singleimagevc.SingleImage = photoGallery[indexPath.row]
        singleimagevc.SingleComment = cellComment[indexPath.row]
        
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
        println("exif: \(attachedExif)")
        file.uploadFileWithPermissions(nil, completion:{(uploadedFile: AnyObject!, error: NSError!) -> Void in
            if uploadedFile != nil {
                println("Object: \(uploadedFile)")
                self.photoGallery.append(photo)
                self.cellComment.append("")
                self.cvEventGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.photoGallery.count-1, inSection: 0)])
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
    
}
