//
//  GalleryVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class GalleryVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    lazy var data = NSMutableData()
    
    let spinner = UIActivityIndicatorView()
    
    @IBOutlet weak var cvGallery: UICollectionView!
    
    //variable for refreshing table data
    var refreshControl:UIRefreshControl!
    
    var downloadedImages = [File]()
    var testimages:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.center = self.cvGallery.center
        self.cvGallery.addSubview(self.spinner)
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.cvGallery.addSubview(refreshControl)
        getBaasImages()
        // Do any additional setup after loading the view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewDidAppear() {
        cvGallery.reloadData()
    }
    
    func refresh(sender:AnyObject){
        println("refresh")
        println("No. of Images \(downloadedImages.count)")
        sleep(1)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.getBaasImages()
            self.cvGallery.reloadData()
        })
        self.refreshControl.endRefreshing()
        
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedImages.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvGalleryCell", forIndexPath: indexPath) as! cvGalleryCell
        cell.backgroundColor = UIColor.blueColor()
        cell.imgGalleryPhoto.image = downloadedImages[indexPath.row].image
        cell.imgGalleryPhoto.contentMode = .ScaleAspectFill

        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        var singleimagevc:SingleImageVC = storyboard?.instantiateViewControllerWithIdentifier("SingleImageVC") as! SingleImageVC
        singleimagevc.SingleImage = downloadedImages[indexPath.row].image
        singleimagevc.User = downloadedImages[indexPath.row].details.author

        //Programmatically push to associated VC
        self.navigationController?.pushViewController(singleimagevc, animated: true)
        
    }
    
    
    let insertIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    class File {
        var details = BAAFile()
        var image = UIImage()
    }
    
    func getBaasImages(){
        BAAFile.loadFilesAndDetailsWithCompletion({(files: [AnyObject]!, error: NSError!) -> () in
            println("files are \(files)")
            if files != nil {
                for file in files {
                    var fileData = File()
                    self.spinner.startAnimating()
                    var image : BAAFile = file as! BAAFile // instance or subclass of BAAFile, previously saved on the server
                    fileData.details = image
                    var params = ["resize":"25%"]
                    image.loadFileWithParameters( params as [NSObject : AnyObject], completion: {(data:NSData!, error:NSError!) -> () in
                        if data != nil {
                            fileData.image = UIImage(data: data)!
                            self.downloadedImages.append(fileData)
                            self.cvGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.downloadedImages.count - 1, inSection: 0)])
                        } else {
                            println("error downloading gallery image")
                        }
                        if self.downloadedImages.count == files.count {
                            self.spinner.stopAnimating()

                        }
                    
                    })
                }
            }
            
        })
    }
}


