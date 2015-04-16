//
//  EventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class EventVC: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var cvComments: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = selectedEvent?.event_name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
