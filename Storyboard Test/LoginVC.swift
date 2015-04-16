//
//  LoginVC.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 21/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController, NSURLConnectionDelegate {
    
    // variable to call the OneShotLocationManager class
    var manager: OneShotLocationManager?
    
    //variable to hold data from NSURLConnection request
    lazy var data = NSMutableData()
    
    var persistenceHelper: PersistenceHelper = PersistenceHelper()

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        self.startConnection()
        
    }


    //creates an NSURLConnectionRequest
    func startConnection(){

            //sets URL path for request using current lat and lon values
            //setup required for NSURLConnection request
            var urlPath = "http://bethehype.co.uk/auth_serv.php?username=\(txtUsername.text)&password=\(txtPassword.text)"
            println(urlPath)
            var url: NSURL = NSURL(string: urlPath)!
            var request: NSURLRequest = NSURLRequest(URL: url)
            var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
            connection.start()

    }
    
    //adds data recieved from the NSURLConnection request to the data variable
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        
        self.data.appendData(data)
    }
    
    var UserID, UserNiceName, UserLogin, UserPass, UserEmail, UserRole, UserLoggedIn, UserStatus, UserRegistered, currentDateTime: AnyObject!
    
    //when all of the data from the NSURLConnection request has been recieved, interpret results as JSON and extract information into variables
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var jsonError: NSError?
        let jsonResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)
        let json = JSON(data: data)
    
        //println(json)
        if json.count != 0 {
            //println(json)
            UserID = json["data"]["ID"].intValue
            UserNiceName = json["data"]["user_nicename"].string
            UserLogin = json["data"]["user_login"].string
            UserPass = json["data"]["user_pass"].string
            UserEmail = json["data"]["user_email"].string
            UserRole = json["data"]["user_role"].string
            UserLoggedIn = true
            UserStatus = json["data"]["user_status"].intValue
            var UserRegDateStr: String = json["data"]["user_registered"].stringValue
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            UserRegistered = dateFormatter.dateFromString(UserRegDateStr)
            currentDateTime = NSDate()
            
            if existingUserCheck(UserID as Int) == false {
                var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
                var context:NSManagedObjectContext = appDel.managedObjectContext!
                let newUser = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context) as Users
                
                newUser.user_id = UserID as Int
                newUser.user_nicename = UserNiceName as String
                newUser.user_login = UserLogin as String
                newUser.user_pass = UserPass as String
                newUser.user_email = UserEmail as String
                //newUser.user_role = UserRole as String
                newUser.user_logged_in = true
                newUser.user_status = UserStatus as Int
                newUser.user_registered = UserRegistered as NSDate
                newUser.user_date_created = currentDateTime as NSDate

                context.save(nil)
                getLoggedInUser()
                
            } else {
                logInUser(UserID as Int)
            }
            
            //userMgr.addUser(UserID, UserNiceName: UserNiceName, UserLogin: UserLogin, UserPass: UserPass, UserEmail: UserEmail, UserRole: UserRole, UserLoggedIn: UserLoggedIn, UserStatus: UserStatus, UserRegistered: UserRegistered, dateTime: currentDateTime)
            if closeEvents.count != 0 {
                if closeEvents[0].locations.distance < 100 {
                    var gigfoundvc:GigFoundVC = storyboard?.instantiateViewControllerWithIdentifier("GigFoundVC") as GigFoundVC
                    let navigationController = UINavigationController(rootViewController: gigfoundvc)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                } else {
                    var menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as MenuTBC
                    menutbc.selectedIndex = 0
                    let navigationController = UINavigationController(rootViewController: menutbc)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                }
            } else {
                var menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as MenuTBC
                menutbc.selectedIndex = 0
                let navigationController = UINavigationController(rootViewController: menutbc)
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
            

        } else {
            let alertController = UIAlertController(title: "Login Error", message:
                "Incorrect Username or Password", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            txtPassword.text = ""
            txtUsername.text = ""
        }
        //clear the data variable for if a second NSURLConnection request is made
        self.data = NSMutableData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if getLoggedInUser() == true {
            if closeEvents.count != 0 {
                if closeEvents[0].locations.distance < 100 {
                    var gigfoundvc:GigFoundVC = storyboard?.instantiateViewControllerWithIdentifier("GigFoundVC") as GigFoundVC
                    let navigationController = UINavigationController(rootViewController: gigfoundvc)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                } else {
                    var menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as MenuTBC
                    menutbc.selectedIndex = 0
                    let navigationController = UINavigationController(rootViewController: menutbc)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                }
            } else {
                var menutbc : MenuTBC = storyboard?.instantiateViewControllerWithIdentifier("MenuTBC") as MenuTBC
                menutbc.selectedIndex = 0
                let navigationController = UINavigationController(rootViewController: menutbc)
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
    }
    
}
