//
//  AltEventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class AltEventVC: UIViewController, UIPageViewControllerDataSource  {
    
    //Initialize a UIPageViewController object.
    var pageViewController = UIPageViewController()
    //var pageTitles = [ "Over 200 Tips and Tricks", "Discover Hidden Features", "Bookmark Favorite Tip", "Free Regular Update" ]
    var pageImagePaths = []
    
    @IBOutlet var btnSelectGig: UIButton!

    
    //MARK: UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var currentVC = viewController as AltEventContentVC
        var index = currentVC.pageIndex
        
        if index == 0 || index != nil {
            return nil
        }
        
        index = index! - 1
        return viewControllerAtIndex(index!)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var currentVC = viewController as AltEventContentVC
        var index = currentVC.pageIndex
        
        if index == nil {
            println("returning nil")
            return nil
        }
        index = index! + 1
        
        if index == closeEvents.count {
            return nil
        }
        
        return viewControllerAtIndex(index!)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return closeEvents.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //Used to generate the ViewControllers at the Index.
    func viewControllerAtIndex( index: Int) -> AltEventContentVC! {
        if closeEvents.count == 0 || index >= closeEvents.count {
            return nil
        }
        
        var pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AltEventContentVC") as AltEventContentVC
        pageContentViewController.titleText = closeEvents[index].event_name
        pageContentViewController.lat = closeEvents[index].locations.location_latitude as Double
        pageContentViewController.lon = closeEvents[index].locations.location_longitude as Double
        pageContentViewController.locname = closeEvents[index].locations.location_name as String
        pageContentViewController.StartDate = "Start Date: \(closeEvents[index].event_start_date as String)"
        pageContentViewController.StartTime = "Start Time: \(closeEvents[index].event_start_time as String)"
        //pageContentViewController.imagePath = self.pageImagePaths[index]
        pageContentViewController.pageIndex = index
        selectedEvent = closeEvents[index]
        
        return pageContentViewController
    }
    
    
    //MARK: ViewDid/Should methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AltEventPVC") as UIPageViewController
        self.pageViewController.dataSource = self
        
        var startingViewController = self.viewControllerAtIndex(0) as AltEventContentVC
        var viewControllers = [startingViewController] as NSArray
        self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
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
