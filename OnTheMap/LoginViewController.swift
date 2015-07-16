//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameString: UITextField!
    
    @IBOutlet weak var passwordString: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        let u = usernameString.text
        let p = passwordString.text
        addSpinner()
        login(u, passwordString: p)
        nextViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loginButton.enabled = true
        loginActivityIndicator.hidden = true
    }
    
    func login(usernameString: String, passwordString: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(usernameString)\", \"password\": \"\(passwordString)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println(error)
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            //TODO:
            // 1. parse JSON
            // 2. check whether "registered" == true
            // 3. if so, present "rootNavVC", passing it the sessionID and the Key
            // 4. if not, UIActivityView error message explaining what went wrong
            // 5. also: spinner to disable view while API call's being made
        }
        task.resume()
    }
    
    func nextViewController() {
        let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier("rootNavVC") as! UINavigationController
        presentViewController(rootNavVC, animated: true, completion: nil)
    }
    
    func addSpinner() {
        loginButton.enabled = false
        loginActivityIndicator.hidden = false
        loginActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loginActivityIndicator.startAnimating()
    }
}
