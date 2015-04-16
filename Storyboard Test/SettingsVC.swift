//
//  SettingsVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 17/02/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        swtchOnlineSearch.on = OnlineSearch
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var swtchOnlineSearch: UISwitch!
    
    @IBAction func swtchOnlineSearch(sender: AnyObject) {
        OnlineSearch = swtchOnlineSearch.on
    }
    
}
