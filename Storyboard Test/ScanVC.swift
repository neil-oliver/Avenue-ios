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
    
    
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var timestamp: NSDate?
    var URL: NSURL?
    var thumbnail: UIImage?
    var image: UIImage?
    var orientation: ALAssetOrientation?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.lblMatchedEvent.text = image.1.event_name as String
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
        self.lblMatchedEvent.text = image.1.event_name as String
        self.btnConfirm.enabled = true
    }
    
    @IBAction func btnConfirm(sender: AnyObject) {
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
                                self.imgScanImageBox.image = photoFull
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                    }
                
                if let location: CLLocation = asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation!
                {
                    lat = location.coordinate.latitude
                    long = location.coordinate.longitude
                    
                    if let photoDate: NSDate = asset.valueForProperty(ALAssetPropertyDate) as! NSDate!
                    {
                        timestamp = photoDate
                        //println("date: \(photoDate)")
                    }
                    
                    if OnlineSearch == true {
                        FetchData().startConnection(lat: lat!, lon: long!)
                    }
                    
                    // creates a bounding box to only get venue details within a sort distance of the current location
                    var latMax: Double = Double(lat!) + 0.005
                    var latMin: Double = Double(lat!) - 0.005
                    var lngMax: Double = Double(long!) + 0.005
                    var lngMin: Double = Double(long!) - 0.005
                    
                    //breaking predicate parameters into variables
                    locationMgr.predicateString = "location_latitude > %f and location_latitude < %f and location_longitude > %f and location_longitude < %f"
                    locationMgr.predicateVars = [latMin, latMax, lngMin, lngMax]
                    
                    
                    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                    var context:NSManagedObjectContext = appDel.managedObjectContext!
                    var request = NSFetchRequest(entityName: "Events")
                    request.returnsObjectsAsFaults = false;
                    request.relationshipKeyPathsForPrefetching = ["locations"]
                    request.predicate = NSPredicate(format: "locations.location_latitude > %f && locations.location_latitude < %f && locations.location_longitude > %f && locations.location_longitude < %f && event_start < %@ && event_end > %@ ", latMin, latMax, lngMin, lngMax, timestamp!, timestamp!)
                    var eventres: NSArray = context.executeFetchRequest(request, error: nil)!
                    resEvents = eventres as! [Events]
                }

                    if resEvents.count == 0 {
                        self.imgScanImageBox.image = image
                        self.lblMatchedEvent.text = "No Event Found"
                        
                        
                        //add selected image to BAAS
                        var data = UIImageJPEGRepresentation(image, 1.0)
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
                        
                        
                        
                    } else {
                        self.imgScanImageBox.image = image
                        self.lblMatchedEvent.text = resEvents[0].event_name as String
                        
                        //add selected image to BAAS
                        var data = UIImageJPEGRepresentation(image, 1.0)
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
        
        self.btnScan.setTitle("Scanning...", forState: UIControlState.Normal)
        scanImages()
    }
        
    var activePhotoIndex: Int?
    var matchedPhotos = [(UIImage,Events)]()

    func scanImages() {
        
        matchedPhotos = [(UIImage,Events)]()
        
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
                                
                                // creates a bounding box to only get venue details within a sort distance of the current location
                                var latMax: Double = Double(self.lat!) + 0.005
                                var latMin: Double = Double(self.lat!) - 0.005
                                var lngMax: Double = Double(self.long!) + 0.005
                                var lngMin: Double = Double(self.long!) - 0.005
                                
                                //breaking predicate parameters into variables
                                locationMgr.predicateString = "location_latitude > %f and location_latitude < %f and location_longitude > %f and location_longitude < %f"
                                locationMgr.predicateVars = [latMin, latMax, lngMin, lngMax]
                                
                                
                                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                                var context:NSManagedObjectContext = appDel.managedObjectContext!
                                var request = NSFetchRequest(entityName: "Events")
                                request.returnsObjectsAsFaults = false;
                                request.relationshipKeyPathsForPrefetching = ["locations"]
                                request.predicate = NSPredicate(format: "locations.location_latitude > %f && locations.location_latitude < %f && locations.location_longitude > %f && locations.location_longitude < %f && event_start < %@ && event_end > %@ ", latMin, latMax, lngMin, lngMax, self.timestamp!, self.timestamp!)
                                var eventres: NSArray = context.executeFetchRequest(request, error: nil)!
                                resEvents = eventres as! [Events]
                                if eventres.count == 0 {
                                    //println("No event found for photo")
                                } else {
                                    //println("Photo \(URL!) was taken at \(resEvents[0].event_name) at \(timestamp!)")
                                    //println(URL!.absoluteString!)
                                    self.matchedPhotos.append((self.image!,resEvents[0]))
                                }
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
                    self.lblMatchedEvent.text = image.1.event_name as String
                    self.btnConfirm.enabled = true
                    
                    //add scanned image to BAAS
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
                    
                }
                
                if self.matchedPhotos.count > 1 {
                    self.btnNext.enabled = true
                }

            }
            })
            { (error) -> Void in
                println("problem loading albums: \(error)")
        }
        
    }
}
