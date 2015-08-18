//
//  ScanVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 17/02/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

/*

//This whole document is implemented in an old way which is now depreciated in iOS 9.0 so it is not currently being used.

import UIKit
import AssetsLibrary
import CoreLocation


class ScanVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let spinner = UIActivityIndicatorView()
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var timestamp: NSDate?
    var URL: NSURL?
    var thumbnail: UIImage?
    var image: UIImage?
    var orientation: ALAssetOrientation?
    
    var baasTime: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.center = self.view.center
        self.spinner.color = UIColor.blackColor()
        self.view.addSubview(self.spinner)
        btnBack.enabled = false
        btnConfirm.enabled = false
        btnNext.enabled = false
        // Do any additional setup after loading the view.
    }

    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var btnNext: UIButton!
    
    
    @IBAction func btnNext(sender: AnyObject) {
        
        activePhotoIndex = activePhotoIndex! + 1
        
        if activePhotoIndex! == (matchedPhotos.count - 1) {
            self.btnNext.enabled = false
        }
        
        if matchedPhotos.count > 1 {
            self.btnBack.enabled = true
        }
        
        
        let image = self.matchedPhotos[self.activePhotoIndex!]
        let photo = image.0
        self.imgScanImageBox.image = photo
        self.lblMatchedEvent.text = image.1.event.displayName as? String
        self.btnConfirm.enabled = true

    }
    
    @IBAction func btnBack(sender: AnyObject) {
        
        activePhotoIndex = activePhotoIndex! - 1
        
        if activePhotoIndex! == 0 {
            self.btnBack.enabled = false
        }
        
        if matchedPhotos.count > 1 {
            self.btnNext.enabled = true
        }
        
        let image = self.matchedPhotos[self.activePhotoIndex!]
        let photo = image.0
        self.imgScanImageBox.image = photo
        self.lblMatchedEvent.text = image.1.event.displayName as? String
        self.btnConfirm.enabled = true
    }
    
    @IBAction func btnConfirm(sender: AnyObject) {
        let data = UIImageJPEGRepresentation(self.matchedPhotos[self.activePhotoIndex!].0, 1.0)
        let file: BAAFile = BAAFile(data: data)
        file.contentType = "image/jpeg"
        print("Uploading Image")
        file.uploadFileWithPermissions(nil, completion:{(uploadedFile: AnyObject!, error: NSError!) -> Void in
            if uploadedFile != nil {
                print("Object: \(uploadedFile)")
                createBaasLink(uploadedFile.fileId, outLink: self.matchedPhotos[self.activePhotoIndex!].1.event.objectId)
            }
            if error != nil {
                print("Upload Error: \(error)")
                let alertController = UIAlertController(title: "Upload Error", message:
                    "Upload Error: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            self.spinner.stopAnimating()
        })
    }
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet var btnSelect: UIButton!
    
    @IBAction func btnSelect(sender: AnyObject) {
        self.btnConfirm.enabled = false
        self.btnBack.enabled = false
        self.btnNext.enabled = false
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]){
    
        var lat: CLLocationDegrees?
        var long: CLLocationDegrees?
        //var timestamp: NSDate?
        var image: UIImage?
        //var resEvents = [Events]()
        var resBaasEvents = [BAALinkedVenueEvents]()
        
        let library = ALAssetsLibrary()
        let url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        library.assetForURL(url, resultBlock: {
            (asset: ALAsset!) in
            if asset != nil {
                
                    if let photoType: NSString = asset.valueForProperty(ALAssetPropertyType) as! NSString!
                    {
                        if photoType == ALAssetTypePhoto
                        {
                            let orientation = UIImageOrientation(rawValue: asset.defaultRepresentation().orientation().rawValue)
                            let scale = CGFloat(asset.defaultRepresentation().scale())
                            
                            let photoFull = UIImage(CGImage:(asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue()), scale: scale, orientation: orientation!)
                            
                                image = photoFull
                                //self.imgScanImageBox.image = photoFull
                                //self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                    }
                
                if let location: CLLocation = asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation!
                {
                    lat = location.coordinate.latitude
                    long = location.coordinate.longitude
                    print("photo coordinates: \(lat!) , \(long!)")
                    
                    if let photoDate: NSDate = asset.valueForProperty(ALAssetPropertyDate) as! NSDate!
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:MM:ss.FFFZ"
                        self.baasTime = dateFormatter.stringFromDate(photoDate as NSDate)
                        print("photo date in baas format: \(self.baasTime)")
                    }
                    
                    if OnlineSearch == true {
                        //FetchData().startConnection(lat: lat!, lon: long!)
                    }
                    
                    let path: NSString = "link"
                    let params: NSDictionary = ["fields" : "out,in, distance(out.lat,out.lng,\(lat!),\(long!)) as distance", "where" : "distance(out.lat,out.lng,\(lat!),\(long!)) < 0.1 and in.start.datetime < date('\(self.baasTime)') and in.end.datetime > date('\(self.baasTime)') and label=\"venue_event\"", "orderBy": "distance asc"]
                    let c = BAAClient.sharedClient()
                    
                    c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                        print("event search results for photo: \(success)")
                        let data: NSDictionary = success as! NSDictionary
                        let dataArray: [AnyObject] = data["data"] as! [AnyObject]
                        if dataArray.count != 0 {
                            for item in dataArray {
                                let venueAndEvent = BAALinkedVenueEvents(dictionary: item as! [NSObject : AnyObject])
                                print("scanned event found: \(venueAndEvent.event.displayName)")
                                print("Distance: \(venueAndEvent.distance)")
                                resBaasEvents.append(venueAndEvent)
                            }
                            
                            if resBaasEvents.count != 0 {
                                self.imgScanImageBox.image = image
                                self.lblMatchedEvent.text = resBaasEvents[0].event.displayName as? String
                                self.spinner.startAnimating()
                                //add selected image to BAAS
                                let data = UIImageJPEGRepresentation(image!, 1.0)
                                let file: BAAFile = BAAFile(data: data)
                                file.contentType = "image/jpeg"
                                print("Uploading Image")
                                file.uploadFileWithPermissions(nil, completion:{(uploadedFile: AnyObject!, error: NSError!) -> Void in
                                    if uploadedFile != nil {
                                        print("Object: \(uploadedFile)")
                                        createBaasLink(uploadedFile.fileId, outLink: resBaasEvents[0].event.objectId)
                                    }
                                    if error != nil {
                                        print("Upload Error: \(error)")
                                        let alertController = UIAlertController(title: "Upload Error", message:
                                            "Upload Error: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                    }
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                    self.spinner.stopAnimating()
                                })
                            }
                        } else {
                            print("No event matched with photo")
                            self.imgScanImageBox.image = image
                            self.lblMatchedEvent.text = "No Event Found"
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                    }, failure:{(failure: NSError!) -> Void in
                        print(failure)
                    })
                } else {
                    self.imgScanImageBox.image = image
                    self.lblMatchedEvent.text = "No GPS Data Found"
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            }, failureBlock: {
                (error: NSError!) in
                
                NSLog("Error!")
            }
        )}
        
    
    @IBOutlet var imgScanImageBox: UIImageView!
    
    @IBOutlet var lblMatchedEvent: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var btnScan: UIButton!
    
    @IBAction func btnScan(sender: AnyObject) {
        
        //self.btnScan.setTitle("Scanning...", forState: UIControlState.Normal)
        //scanImages()
        
        
        let alertController = UIAlertController(title: "Coming Soon...", message:
            "This option does not currently work with the BaasBox server.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    var activePhotoIndex: Int?
    var matchedPhotos = [(UIImage,BAALinkedVenueEvents)]()

    func scanImages() {
        self.spinner.startAnimating()

        matchedPhotos = [(UIImage,BAALinkedVenueEvents)]()
        
        let library = ALAssetsLibrary()
        library.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: { (group, stop) -> Void in
            if (group != nil) {
            
                print("Group \((group.valueForProperty(ALAssetsGroupPropertyName))) is not nil")
                if group.valueForProperty(ALAssetsGroupPropertyName) as! NSString == "All Photos" {
                    group.enumerateAssetsUsingBlock { (asset, index, stop) in
                        if asset != nil
                        {
                            if let location: CLLocation = asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation!
                            {
                                self.lat = location.coordinate.latitude
                                self.long = location.coordinate.longitude
                                //println("lat: \(lat), lon: \(long)")
                            
                                if let photoDate: NSDate = asset.valueForProperty(ALAssetPropertyDate) as! NSDate!
                                {
                                    self.timestamp = photoDate
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:MM:ss.FFFZ"
                                    self.baasTime = dateFormatter.stringFromDate(photoDate as NSDate)
                                    print("photo date in baas format: \(self.baasTime)")
                                    //println("date: \(photoDate)")
                                }
                                
                                
                                if let photoThumb: UIImage = UIImage(CGImage: asset.thumbnail().takeUnretainedValue()) as UIImage!
                                {
                                    self.thumbnail = photoThumb
                                }
                                
                                if let photoType: NSString = asset.valueForProperty(ALAssetPropertyType) as! NSString!
                                {
                                    if photoType == ALAssetTypePhoto
                                    {
                                        let orientation = UIImageOrientation(rawValue: asset.defaultRepresentation().orientation().rawValue)
                                        let scale = CGFloat(asset.defaultRepresentation().scale())
                                        
                                        let photoFull =  UIImage(CGImage:(asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue()), scale: scale, orientation: orientation!)
                                        
                                            self.image = photoFull
                                    }
                                }
                                
                                
                                var resBaasEvents = [BAALinkedVenueEvents]()
                                
                                let path: NSString = "link"
                                let params: NSDictionary = ["fields" : "out,in, distance(out.lat,out.lng,\(self.lat!),\(self.long!)) as distance", "where" : "distance(out.lat,out.lng,\(self.lat!),\(self.long!)) < 0.1 and in.start.datetime < date('\(self.baasTime)') and in.end.datetime > date('\(self.baasTime)') and label=\"venue_event\"", "orderBy": "distance asc"]
                                let c = BAAClient.sharedClient()
                                
                                c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                                    if success != nil {
                                        print("event search results for photo: \(success)")
                                        let data: NSDictionary = success as! NSDictionary
                                        let dataArray: [AnyObject] = data["data"] as! [AnyObject]
                                        if dataArray.count != 0 {
                                            for item in dataArray {
                                                let venueAndEvent = BAALinkedVenueEvents(dictionary: item as! [NSObject : AnyObject])
                                                print("scanned event found: \(venueAndEvent.event.displayName)")
                                                print("Distance: \(venueAndEvent.distance)")
                                                resBaasEvents.append(venueAndEvent)
                                            }
                                        }
                                        //self.matchedPhotos.append(self.image!,resBaasEvents[0])
                                        self.spinner.stopAnimating()
                                    } else {
                                       self.spinner.stopAnimating()
                                    }
                                    }, failure:{(failure: NSError!) -> Void in
                                        print(failure)
                                })
                                
                            }
                        }
                    }
                }
            } else {
                self.btnScan.setTitle("Scan", forState: UIControlState.Normal)
                
                print("The group is empty!")
                print("No. of matched photo \(self.matchedPhotos.count)")
                if self.matchedPhotos.count != 0 {
                    self.activePhotoIndex = 0
                    let image = self.matchedPhotos[self.activePhotoIndex!]
                    let photo = image.0
                    self.imgScanImageBox.image = photo
                    self.lblMatchedEvent.text = image.1.event.displayName as? String
                    self.btnConfirm.enabled = true
                    
                    //add scanned image to BAAS
                    self.spinner.startAnimating()
                    let data = UIImageJPEGRepresentation(photo, 1.0)
                    let file: BAAFile = BAAFile(data: data)
                    file.contentType = "image/jpeg"
                    file.uploadFileWithPermissions(nil, completion:{(uploadedFile: AnyObject!, error: NSError!) -> Void in
                    if uploadedFile != nil {
                    print("Object: \(uploadedFile)")
                    }
                    if error != nil {
                    print("Upload Error: \(error)")
                    }
                    })
                    self.spinner.stopAnimating()
                } else {
                    self.spinner.stopAnimating()
                    let alertController = UIAlertController(title: "Photo Scanning", message:
                        "No photos were found to be taken at any of the gigs we have listed.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                if self.matchedPhotos.count > 1 {
                    self.btnNext.enabled = true
                }

            }
            })
            { (error) -> Void in
                print("problem loading albums: \(error)")
                self.spinner.stopAnimating()
        }
        
    }
}
*/

