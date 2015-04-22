//
//  EventVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit

class EventVC: UIViewController {


    @IBOutlet var txtComment: UITextField!
    
    @IBAction func btnSend(sender: AnyObject) {
        
        var newComment : BAAComment = BAAComment()
        newComment.comment = txtComment.text
        
        newComment.saveObjectWithCompletion({(object:AnyObject!, error: NSError!) -> Void in
            if object != nil {
                println("Object: \(object)")
                self.txtComment.text = ""
            }
            if error != nil {
                println("Error: \(error)")
            }
        })
        
    }
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var cvComments: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = selectedEvent?.event_name as? String
        self.navigationController!.toolbarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
