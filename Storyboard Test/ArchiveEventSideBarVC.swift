//
//  ArchiveEventSideBarVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 29/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import Spring

class ArchiveEventSideBarVC: UIViewController {

    @IBOutlet weak var modalView: SpringView!
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalView.transform = CGAffineTransformMakeTranslation(-300, 0)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        
        modalView.animation = "slideRight"
        modalView.animateFrom = false
        modalView.animateToNext({
            self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        modalView.animate()
    }

}
