//
//  AltEventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import MapKit

class AltEventVC: UIViewController, UIPageViewControllerDataSource  {
    
    //Initialize a UIPageViewController object.
    var pageViewController = UIPageViewController()
    
    @IBOutlet var btnSelectGig: UIButton!

    //MARK: UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        

        let currentVC = viewController as! AltEventContentVC
        var index = currentVC.pageIndex
        
        if index == 0 || index != nil {
            return nil
        }
        
        index = index! - 1
        return viewControllerAtIndex(index!)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let currentVC = viewController as! AltEventContentVC
        var index = currentVC.pageIndex

        if index == nil {
            print("returning nil")
            return nil
        }
        index = index! + 1
        
        if index == closeVenueEvents.count {
            return nil
        }
        
        return viewControllerAtIndex(index!)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return closeVenueEvents.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //Used to generate the ViewControllers at the Index.
    func viewControllerAtIndex( index: Int) -> AltEventContentVC! {
        if closeVenueEvents.count == 0 || index >= closeVenueEvents.count {
            return nil
        }
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AltEventContentVC") as! AltEventContentVC
        pageContentViewController.titleText = closeVenueEvents[index].event.displayName as? String
        pageContentViewController.location = CLLocationCoordinate2D(
            latitude: closeVenueEvents[index].venue.lat as! Double,
            longitude: closeVenueEvents[index].venue.lng as! Double
        )
        pageContentViewController.locname = closeVenueEvents[index].venue.displayName as! String
        pageContentViewController.StartDate = "Start Date: \(closeVenueEvents[index].event.start.date as! String)"
        pageContentViewController.StartTime = "Start Time: \(closeVenueEvents[index].event.start.time as! String)"
        pageContentViewController.pageIndex = index
        selectedEvent = closeVenueEvents[index]
        let alertController = UIAlertController(title: "SelectedEvent Variable", message:
            "The current gig in the selectedEvent Variable is: \(closeVenueEvents[index].event.displayName)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        print(selectedEvent!.event.displayName)
        
        return pageContentViewController
    }
    
    
    //MARK: ViewDid/Should methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AltEventPVC") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startingViewController = self.viewControllerAtIndex(0) as AltEventContentVC
        let viewControllers = [startingViewController] as NSArray
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)

        //Size of the VC
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
