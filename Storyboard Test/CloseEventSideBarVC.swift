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
        
        lblVenueTitle.text = selectedEvent?.venue.displayName as? String
        
        let lat = selectedEvent?.venue.lat as! Double
        let lon = selectedEvent?.venue.lng as! Double
        
        let location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: lon
        )
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = selectedEvent?.venue.displayName as? String
        map.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
