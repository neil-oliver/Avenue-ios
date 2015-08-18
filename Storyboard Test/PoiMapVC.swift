//
//  PoiMapVC.swift
//  Avenue
//
//  Created by Neil Oliver on 24/06/2015.
//  Copyright © 2015 Neil Oliver. All rights reserved.
//

import UIKit
import MapKit
import CoreGraphics


class PoiMapVC: UIViewController, MKMapViewDelegate, MBXRasterTileOverlayDelegate {
    
    @IBOutlet var annotationButton: UIButton!
    
    var selectVenue: Bool = false
    /*
    var bristolAcademy = [CLLocationCoordinate2DMake(51.454219, -2.600308),
        CLLocationCoordinate2DMake(51.454460, -2.599822),
        CLLocationCoordinate2DMake(51.454928, -2.600439),
        CLLocationCoordinate2DMake(51.454687, -2.600917)]

    var hatchett = [CLLocationCoordinate2DMake(51.453864, -2.600512),
    CLLocationCoordinate2DMake(51.453874, -2.600498),
    CLLocationCoordinate2DMake(51.453858, -2.600466),
    CLLocationCoordinate2DMake(51.453894, -2.600408),
    CLLocationCoordinate2DMake(51.453886, -2.600394),
    CLLocationCoordinate2DMake(51.453934, -2.600314),
    CLLocationCoordinate2DMake(51.453944, -2.600328),
    CLLocationCoordinate2DMake(51.453986, -2.600259),
    CLLocationCoordinate2DMake(51.454077, -2.600396),
    CLLocationCoordinate2DMake(51.454045, -2.600455),
    CLLocationCoordinate2DMake(51.454048, -2.600463),
    CLLocationCoordinate2DMake(51.453995, -2.600551),
    CLLocationCoordinate2DMake(51.453987, -2.600546),
    CLLocationCoordinate2DMake(51.453953, -2.600604),
    CLLocationCoordinate2DMake(51.453912, -2.600556),
    CLLocationCoordinate2DMake(51.453904, -2.600567)]
    */
    
    
    @IBAction func btnOverlay(sender: AnyObject) {
        
        if selectVenue == false {
            selectVenue = true
            let overlay = MyMapOverlay(coords: self.PoiMap.userLocation.coordinate)
            self.PoiMap.addOverlay(overlay, level: .AboveLabels)
            
            
            for annotation in self.PoiMap.annotations{
                let annotationLocation: CLLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let userCurrentLocation: CLLocation = CLLocation(latitude: self.PoiMap.userLocation.coordinate.latitude, longitude: self.PoiMap.userLocation.coordinate.longitude)
                let distance = annotationLocation.distanceFromLocation(userCurrentLocation)
                print(distance, appendNewline: true)
                if distance > 500 {
                    if annotation is MKPointAnnotation {
                        let removeView = self.PoiMap.viewForAnnotation(annotation) as! MKPinAnnotationView
                        removeView.enabled = false
                        removeView.pinTintColor = UIColor.grayColor()
                    }
                }
            }
        } else {
            selectVenue = false
            let overlay = self.PoiMap.overlays[1]
            self.PoiMap.removeOverlay(overlay)
            
            for annotation in self.PoiMap.annotations{
                if annotation is MKPointAnnotation {
                    let updateView = self.PoiMap.viewForAnnotation(annotation) as! MKPinAnnotationView
                    updateView.enabled = true
                    updateView.pinTintColor = UIColor.redColor()
                }
            }
        }
    }

    @IBAction func button(sender: AnyObject) {
        createAnnotations()
        annotationButton.enabled = false
        //let academy: MKPolygon = MKPolygon(coordinates: &bristolAcademy, count: bristolAcademy.count)
        //self.PoiMap.addOverlay(academy)
        //let hatch: MKPolygon = MKPolygon(coordinates: &hatchett, count: hatchett.count)
        //self.PoiMap.addOverlay(hatch)
        
        //disabled while i work out geoJSON
        /*
        for single in closeVenueEvents {
            let venueOverlay: MKPolygon = MKPolygon(coordinates: &single.venue.geometry.points, count: single.venue.geometry.points.count)
            self.PoiMap.addOverlay(venueOverlay)
        }
        */
    }
    
    @IBOutlet var PoiMap: MKMapView!
    
    var location : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        annotationButton.enabled = true
        FetchData().getLocation(){(locationSet: Bool) in
            
            self.location = locationObj.coordinate
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: self.location, span: span)
            self.PoiMap.showsUserLocation = true
            self.PoiMap.setRegion(region, animated: true)
            
            self.PoiMap.showsBuildings = false
            self.PoiMap.rotateEnabled = false
            self.PoiMap.pitchEnabled = false
            
            MBXMapKit.setAccessToken("pk.eyJ1IjoianVzdGluIiwiYSI6IlpDbUJLSUEifQ.4mG8vhelFMju6HpIY-Hi5A")
            let rasterOverlay = MBXRasterTileOverlay(mapID: "neiloliver.5d32c838")
            self.PoiMap.delegate = self
            self.PoiMap.addOverlay(rasterOverlay)
            /*
            if closeVenueEvents.count > 0 {
                self.createAnnotations()
            } else {
                let alertController = UIAlertController(title: "Close Events", message:
                    "No Events Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            */
        }
        
    }
    
    
    func createAnnotations() {
        print(venuesWithLinks, appendNewline: true)

        for single in venuesWithLinks {
            let venue = single as BAAVenue
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: (venue.address.lat as? Double)!,
                longitude: (venue.address.lng as? Double)!
            )
            
            annotation.title = venue.displayName as? String
            self.PoiMap.addAnnotation(annotation)
        }
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        print("viewforannotation", appendNewline: true)
        let reuseId = "test"
        var anView: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                anView = dequeuedView
        } else {
            anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            if (annotation.title! == "disable") {
                anView.enabled = false
                anView.pinTintColor = UIColor.grayColor()
            } else {
                anView.canShowCallout = true
                anView.rightCalloutAccessoryView = UIButton(type:.DetailDisclosure) as UIView
                anView.animatesDrop = true
            }
        }
        
        return anView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("hello", appendNewline: true)
        if selectVenue == false {
            let venueeventsvc:venueEventsVC = storyboard?.instantiateViewControllerWithIdentifier("venueEventsVC") as! venueEventsVC
            //Programmatically push to associated VC (EventsVC)
            venueeventsvc.selectedVenueName = view.annotation?.title!
            let navigationController = UINavigationController(rootViewController: venueeventsvc)
            self.presentViewController(navigationController, animated: true, completion: nil)
        } else {
            for event in closeVenueEvents{
                let baaEvent = event as BAALinkedVenueEvents
                if baaEvent.venue.displayName as! String == (view.annotation?.title!)! {
                selectedEvent = baaEvent
                let eventvc:EventVC = storyboard?.instantiateViewControllerWithIdentifier("EventVC") as! EventVC
                //Programmatically push to associated VC (EventsVC)
                //eventvc.lblTitle.text = view.annotation?.title!
                let navigationController = UINavigationController(rootViewController: eventvc)
                self.presentViewController(navigationController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MBXRasterTileOverlay {
                let renderer = MBXRasterTileRenderer(overlay: overlay)
                return renderer
                
            } else if overlay is MKPolygon {
                let polygonRenderer = MKPolygonRenderer(overlay: overlay)
                polygonRenderer.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.2)
                //polygonRenderer.strokeColor = UIColor.cyanColor().colorWithAlphaComponent(0.7)
                //polygonRenderer.lineWidth = 1
                return polygonRenderer
            } else {
                /// we need to draw overlay on the map in a way when everything except the area in radius of 500 should be grayed
                /// to do that there is special renderer implemented - NearbyMapOverlay
                if overlay is MyMapOverlay {
                    let renderer = MyMapOverlayRenderer(overlay: overlay)
                    renderer.fillColor = UIColor.blackColor().colorWithAlphaComponent(1)/// specify color which you want to use for gray out everything out of radius
                    renderer.diameterInMeters = 1000 /// choose whatever diameter you need
                    
                    return renderer
                } else {
                    return MKOverlayRenderer() // should be nil but xcode 7 is being silly
                    
                }

            }
    }


    
    func mapView(mapView: MKMapView, viewForAnnoation annotation: MKAnnotation) -> MKAnnotationView {
        if annotation is MBXPointAnnotation {
            let MBXSimpleStyleReuseIdentifier: String = "MBXSimpleStyleReuseIdentifier"
            var view: MKAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(MBXSimpleStyleReuseIdentifier)!
            if (view != nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: MBXSimpleStyleReuseIdentifier)
            }
            let pointAnnotation: MBXPointAnnotation = annotation as! MBXPointAnnotation
            view!.image = pointAnnotation.image
            view!.canShowCallout = true
            return view!
        }
        return MKAnnotationView() // these should be nil but xcode 7 is being stupid!
    }
    
    
    func tileOverlay(overlay: MBXRasterTileOverlay!, didLoadMetadata metadata: [NSObject : AnyObject]!, withError error: NSError!) {
        if (error != nil) {
            print("Failed to load metadata for map ID \(overlay.mapID) - (\(error))", appendNewline: true)
        } else {
            
            self.PoiMap.mbx_setCenterCoordinate(overlay.center, zoomLevel: UInt(overlay.centerZoom), animated: false)
        }
    }
    
    
    func tileOverlay(overlay: MBXRasterTileOverlay!, didLoadMarkers markers: [AnyObject]!, withError error: NSError!) {
        if (error != nil) {
            print("Failed to load metadata for map ID \(overlay.mapID) - (\(error))", appendNewline: true)
        } else {
            self.PoiMap.addAnnotations(markers as! [MKAnnotation])
            
        }
    }
    
    func tileOverlayDidFinishLoadingMetadataAndMarkers(overlay: MBXRasterTileOverlay!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    class MyMapOverlay: NSObject, MKOverlay {
        
        var coordinate: CLLocationCoordinate2D
        var boundingMapRect: MKMapRect
        
        init(coords: CLLocationCoordinate2D) {
            boundingMapRect = MKMapRectWorld
            coordinate = coords
        }
    }
    
}

class MyMapOverlayRenderer: MKOverlayRenderer {
    var diameterInMeters: Double!
    var fillColor: UIColor!
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
        
        /// main path - whole area
        let path = UIBezierPath(rect: CGRectMake(CGFloat(mapRect.origin.x), CGFloat(mapRect.origin.y), CGFloat(mapRect.size.width), CGFloat(mapRect.size.height)))
        
        /// converting to the 'world' coordinates
        let radiusInMapPoints: Double = self.diameterInMeters * MKMapPointsPerMeterAtLatitude(self.overlay.coordinate.latitude)
        let radiusSquared : MKMapSize = MKMapSize(width: radiusInMapPoints, height: radiusInMapPoints)
        let regionOrigin: MKMapPoint = MKMapPointForCoordinate(self.overlay.coordinate)
        var regionRect: MKMapRect = MKMapRect(origin: regionOrigin, size: radiusSquared) //origin is the top-left corner
        regionRect = MKMapRectOffset(regionRect, -radiusInMapPoints / 2, -radiusInMapPoints / 2)
        // clamp the rect to be within the world
        regionRect = MKMapRectIntersection(regionRect, MKMapRectWorld)
        
        /// next path is used for excluding the area within the specific radius from current user location, so it will not be filled by overlay fill color
        let excludePath = UIBezierPath(roundedRect: CGRectMake(CGFloat(regionRect.origin.x), CGFloat(regionRect.origin.y), CGFloat(regionRect.size.width), CGFloat(regionRect.size.height)), cornerRadius: CGFloat(regionRect.size.width / 2))
        
        path.appendPath(excludePath)
        
        /// setting overlay fill color
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor)
        /// adding main path. NOTE that exclusionPath was appended to main path, so we should only add 'path'
        CGContextAddPath(context, path.CGPath)
        /// tells the context to fill the path but with regards to even odd rule
        CGContextEOFillPath(context)
        
        
    }
}



