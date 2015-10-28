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
    
    @IBAction func btnOverlay(sender: AnyObject) {
        
        if selectVenue == false {
            selectVenue = true
            let overlay = MyMapOverlay(coords: self.PoiMap.userLocation.coordinate)
            self.PoiMap.addOverlay(overlay, level: .AboveLabels)
            
            
            for annotation in self.PoiMap.annotations{
                let annotationLocation: CLLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let userCurrentLocation: CLLocation = CLLocation(latitude: self.PoiMap.userLocation.coordinate.latitude, longitude: self.PoiMap.userLocation.coordinate.longitude)
                let distance = annotationLocation.distanceFromLocation(userCurrentLocation)
                print(distance, terminator: "\n")
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
        
        
        for single in closeVenueEvents {
            print("venue: \(single.venue.displayName)")
            print("data: \(single.venue.blueprint.points as? NSDictionary)")
            if let data = single.venue.blueprint.points as? NSDictionary {
                let venueOverlay: MKPolygon = JSONPolygon(single.venue.blueprint.points as! NSDictionary)
                self.PoiMap.addOverlay(venueOverlay)
            }
        }

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

        }
        
    }
    
    
    func createAnnotations() {
        print(venuesWithLinks, terminator: "\n")

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
        print("viewforannotation", terminator: "\n")
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
        print("hello", terminator: "\n")
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
                polygonRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.7)
                polygonRenderer.strokeColor = UIColor.purpleColor().colorWithAlphaComponent(1)
                polygonRenderer.lineWidth = 5
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
            print("Failed to load metadata for map ID \(overlay.mapID) - (\(error))", terminator: "\n")
        } else {
            
            self.PoiMap.mbx_setCenterCoordinate(overlay.center, zoomLevel: UInt(overlay.centerZoom), animated: false)
        }
    }
    
    
    func tileOverlay(overlay: MBXRasterTileOverlay!, didLoadMarkers markers: [AnyObject]!, withError error: NSError!) {
        if (error != nil) {
            print("Failed to load metadata for map ID \(overlay.mapID) - (\(error))", terminator: "\n")
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



