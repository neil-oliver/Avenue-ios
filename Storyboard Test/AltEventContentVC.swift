//
//  AltEventContentVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 11/12/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import MapKit

class AltEventContentVC: UIViewController {
    
    //Variables to make a Page Content View Controller work.
    var pageIndex : Int?
    var titleText : String?
    var imagePath : String?
    var lat: Double = 0
    var lon: Double = 0
    var locname: String = ""
    var StartTime: String = ""
    var StartDate: String = ""
    //To have a label for a childVC and a background image for the child VC.
    //@IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var lblAltEventTitle: UILabel!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAltEventTitle.text = titleText
        lblStartDate.text = StartDate
        lblStartTime.text = StartTime
        
        // Do any additional setup after loading the view.
        //self.backgroundImageView.image = UIImage(named: self.imagePath!)
        //self.titleLabel.text = self.titleText

        
        var location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: lon
        )
        
        var span = MKCoordinateSpanMake(0.01, 0.01)
        var region = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = locname
        map.addAnnotation(annotation)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
