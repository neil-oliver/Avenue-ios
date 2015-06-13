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
    var SingleComment: String = ""
    var User: String = ""
    
    @IBOutlet var imgSingle: UIImageView!
    @IBOutlet var lblComment: UILabel!
    @IBOutlet var btnUser: UIButton!
    
    @IBAction func btnUserSelect(sender: AnyObject) {
        let profilevc : ProfileVC = storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileVC
        profilevc.selectedUser = User
        //Programmatically push to associated VC
        self.navigationController?.pushViewController(profilevc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgSingle.image = SingleImage!
        lblComment.text = SingleComment
        btnUser.setTitle(User, forState: UIControlState.Normal)
        self.view.backgroundColor = UIColor.blackColor()

        // Do any additional setup after loading the view.
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
