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
    
    @IBOutlet weak var cvGallery: UICollectionView!
    //variable for refreshing table data
    var refreshControl:UIRefreshControl!
    
    var downloadedImages:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startConnection()
        //BaasBox.setBaseURL("http://localhost:9000", appCode: "1234567890")
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.cvGallery.addSubview(refreshControl)
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
            self.startConnection()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvGalleryCell", forIndexPath: indexPath) as cvGalleryCell
        cell.backgroundColor = UIColor.blueColor()
        cell.imgGalleryPhoto.image = downloadedImages[indexPath.row]
        cell.imgGalleryPhoto.contentMode = .ScaleAspectFill

        return cell
    }
    
    let insertIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    
    func startConnection(){
        let urlPath: String = "http://bethehype.co.uk/photo-stream"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var jsonError: NSError?
        let jsonResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)
        let json = JSON(data: data)
        
        for (key, subJson) in json {
            if let guid = subJson["guid"].string {
                println(guid)
                var url: NSURL!
                url  = NSURL(string: guid)
                downloadImage(url, {image, error in
                    self.downloadedImages.append(image)
                    self.cvGallery.insertItemsAtIndexPaths([NSIndexPath(forItem: self.downloadedImages.count - 1, inSection: 0)])
                    println(self.downloadedImages.count)
                })
            }
        }
    }

    

    func downloadImage(url: NSURL, handler: ((image: UIImage, NSError!) -> Void))
    {
        var imageRequest: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(imageRequest,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{response, data, error in
                handler(image: UIImage(data: data)!, error)
        })
    }

}


