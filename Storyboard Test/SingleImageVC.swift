//
//  SingleImageVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 25/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import UIKit


class SingleImageVC: UIViewController {

    var SingleImage: UIImage!
    @IBOutlet var imgSingle: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgSingle.image = SingleImage!
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
