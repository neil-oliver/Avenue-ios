//
//  CloseEventSideBarVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 29/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import MapKit

class CloseEventSideBarVC: UIViewController {
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var lblVenueTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblVenueTitle.text = seletedCloseEvent?.locations.location_name as? String
        
        var lat = seletedCloseEvent?.locations.location_latitude as! Double
        var lon = seletedCloseEvent?.locations.location_longitude as! Double
        
        var location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: lon
        )
        
        var span = MKCoordinateSpanMake(0.01, 0.01)
        var region = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = seletedCloseEvent?.locations.location_name as! String
        map.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
