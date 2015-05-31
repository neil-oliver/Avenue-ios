//
//  ScanVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 17/02/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import UIKit
import AssetsLibrary
import CoreLocation
import CoreData


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
        
        
        var image = self.matchedPhotos[self.activePhotoIndex!]
        var photo = image.0
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
        
        var image = self.matchedPhotos[self.activePhotoIndex!]
        var photo = image.0
        self.imgScanImageBox.image = photo
        self.lblMatchedEvent.text = image.1.event.displayName as? String
        self.btnConfirm.enabled = true
    }
    
    @IBAction func btnConfirm(sender: AnyObject) {
        var data = UIImageJPEGRepresentation(self.matchedPhotos[self.activePhotoIndex!].0, 1.0)
        var file: BAAFile = BAAFile(data: data)
        file.contentType = "image/jpeg"
        println("Uploading Image")
        file.uploadFileWithPermissions(nil, completion:{(uploadedFile: AnyObject!, error: NSError!) -> Void in
            if uploadedFile != nil {
                println("Object: \(uploadedFile)")
                createBaasLink(uploadedFile.fileId, self.matchedPhotos[self.activePhotoIndex!].1.event.objectId)
            }
            if error != nil {
                println("Upload Error: \(error)")
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    
        var lat: CLLocationDegrees?
        var long: CLLocationDegrees?
        var timestamp: NSDate?
        var image: UIImage?
        var resEvents = [Events]()
        var resBaasEvents = [BAALinkedVenueEvents]()
        
        let library = ALAssetsLibrary()
        var url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        library.assetForURL(url, resultBlock: {
            (asset: ALAsset!) in
            if asset != nil {
                
                    if let photoType: NSString = asset.valueForProperty(ALAssetPropertyType) as! NSString!
                    {
                        if photoType == ALAssetTypePhoto
                        {
                            var orientation = UIImageOrientation(rawValue: asset.defaultRepresentation().orientation().rawValue)
                            var scale = CGFloat(asset.defaultRepresentation().scale())
                            
                            if let photoFull =  UIImage(CGImage:(asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue()), scale: scale, orientation: orientation!)
                            {
                                image = photoFull
                                //self.imgScanImageBox.image = photoFull
                                //self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                    }
                
                if let location: CLLocation = asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation!
                {
                    lat = location.coordinate.latitude
                    long = location.coordinate.longitude
                    println("photo coordinates: \(lat!) , \(long!)")
                    
                    if let photoDate: NSDate = asset.valueForProperty(ALAssetPropertyDate) as! NSDate!
                    {
                        timestamp = photoDate
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:MM:ss.FFFZ"
                        self.baasTime = dateFormatter.stringFromDate(photoDate as NSDate)
                        println("photo date in baas format: \(self.baasTime)")
                    }
                    
                    if OnlineSearch == true {
                        //FetchData().startConnection(lat: lat!, lon: long!)
                    }
                    
                    var path: NSString = "link"
                    var params: NSDictionary = ["fields" : "out,in, distance(out.lat,out.lng,\(lat!),\(long!)) as distance", "where" : "distance(out.lat,out.lng,\(lat!),\(long!)) < 0.1 and in.start.datetime < date('\(self.baasTime)') and in.end.datetime > date('\(self.baasTime)') and label=\"venue_event\"", "orderBy": "distance asc"]
                    var c = BAAClient.sharedClient()
                    
                    c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                        println("event search results for photo: \(success)")
                        var data: NSDictionary = success as! NSDictionary
                        var dataArray: [AnyObject] = data["data"] as! [AnyObject]
                        if dataArray.count != 0 {
                            for item in dataArray {
                                var venueAndEvent = BAALinkedVenueEvents(dictionary: item as! [NSObject : AnyObject])
                                println("scanned event found: \(venueAndEvent.event.displayName)")
                                println("Distance: \(venueAndEvent.distance)")
                                resBaasEvents.append(venueAndEvent)
                            }
                            
                            if resBaasEvents.count != 0 {
                                self.imgScanImageBox.image = image
                                self.lblMatchedEvent.text = resBaasEvents[0].event.displayName as? String
                                self.spinner.startAnimating()
                                //add selected image to BAAS
                                var data = UIImageJPEGRepresentation(image, 1.0)
                                var file: BAAFile = BAAFile(data: data)
                                file.contentType = "image/jpeg"
                                println("Uploading Image")
                                file.uploadFileWithPermissions(nil, completion:{(uploadedFile: AnyObject!, error: NSError!) -> Void in
                                    if uploadedFile != nil {
                                        println("Object: \(uploadedFile)")
                                        createBaasLink(uploadedFile.fileId, resBaasEvents[0].event.objectId)
                                    }
                                    if error != nil {
                                        println("Upload Error: \(error)")
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
                            println("No event matched with photo")
                            self.imgScanImageBox.image = image
                            self.lblMatchedEvent.text = "No Event Found"
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                    }, failure:{(failure: NSError!) -> Void in
                        println(failure)
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
        
        var library = ALAssetsLibrary()
        library.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: { (group, stop) -> Void in
            if (group != nil) {
            
                println("Group \((group.valueForProperty(ALAssetsGroupPropertyName))) is not nil")
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
                                    println("photo date in baas format: \(self.baasTime)")
                                    //println("date: \(photoDate)")
                                }
                                
                                if let photoURL: NSURL = asset.valueForProperty(ALAssetPropertyAssetURL) as! NSURL!
                                {
                                    self.URL = photoURL
                                    let absoluteURL = photoURL.absoluteString!
                                    //println("URL: \(absoluteURL)")
                                }
                                
                                if let photoThumb: UIImage = UIImage(CGImage: asset.thumbnail().takeUnretainedValue()) as UIImage!
                                {
                                    self.thumbnail = photoThumb
                                }
                                
                                if let photoType: NSString = asset.valueForProperty(ALAssetPropertyType) as! NSString!
                                {
                                    if photoType == ALAssetTypePhoto
                                    {
                                        var orientation = UIImageOrientation(rawValue: asset.defaultRepresentation().orientation().rawValue)
                                        var scale = CGFloat(asset.defaultRepresentation().scale())
                                        
                                        if let photoFull =  UIImage(CGImage:(asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue()), scale: scale, orientation: orientation!)
                                        {
                                            self.image = photoFull

                                        }
                                    }
                                }
                                
                                if let photoOrientation: ALAssetOrientation = asset.defaultRepresentation().orientation() as ALAssetOrientation!
                                {
                                    
                                }
                                
                                var resEvents = [Events]()
                                var resBaasEvents = [BAALinkedVenueEvents]()
                                
                                var path: NSString = "link"
                                var params: NSDictionary = ["fields" : "out,in, distance(out.lat,out.lng,\(self.lat!),\(self.long!)) as distance", "where" : "distance(out.lat,out.lng,\(self.lat!),\(self.long!)) < 0.1 and in.start.datetime < date('\(self.baasTime)') and in.end.datetime > date('\(self.baasTime)') and label=\"venue_event\"", "orderBy": "distance asc"]
                                var c = BAAClient.sharedClient()
                                
                                c.getPath(path as String, parameters: params as [NSObject : AnyObject], success:{(success: AnyObject!) -> Void in
                                    if success != nil {
                                        println("event search results for photo: \(success)")
                                        var data: NSDictionary = success as! NSDictionary
                                        var dataArray: [AnyObject] = data["data"] as! [AnyObject]
                                        if dataArray.count != 0 {
                                            for item in dataArray {
                                                var venueAndEvent = BAALinkedVenueEvents(dictionary: item as! [NSObject : AnyObject])
                                                println("scanned event found: \(venueAndEvent.event.displayName)")
                                                println("Distance: \(venueAndEvent.distance)")
                                                resBaasEvents.append(venueAndEvent)
                                            }
                                        }
                                        self.matchedPhotos.append((self.image!,resBaasEvents[0]))
                                        self.spinner.stopAnimating()
                                    } else {
                                       self.spinner.stopAnimating()
                                    }
                                    }, failure:{(failure: NSError!) -> Void in
                                        println(failure)
                                })
                                
                            }
                        }
                    }
                }
            } else {
                self.btnScan.setTitle("Scan", forState: UIControlState.Normal)
                
                println("The group is empty!")
                println("No. of matched photo \(self.matchedPhotos.count)")
                if self.matchedPhotos.count != 0 {
                    self.activePhotoIndex = 0
                    var image = self.matchedPhotos[self.activePhotoIndex!]
                    var photo = image.0
                    self.imgScanImageBox.image = photo
                    self.lblMatchedEvent.text = image.1.event.displayName as? String
                    self.btnConfirm.enabled = true
                    
                    //add scanned image to BAAS
                    self.spinner.startAnimating()
                    var data = UIImageJPEGRepresentation(photo, 1.0)
                    var file: BAAFile = BAAFile(data: data)
                    file.contentType = "image/jpeg"
                    file.uploadFileWithPermissions(nil, completion:{(uploadedFile: AnyObject!, error: NSError!) -> Void in
                    if uploadedFile != nil {
                    println("Object: \(uploadedFile)")
                    }
                    if error != nil {
                    println("Upload Error: \(error)")
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
                println("problem loading albums: \(error)")
                self.spinner.stopAnimating()
        }
        
    }
}
