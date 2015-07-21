//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var firstName = "Swing"
    var lastName = "Kids"
    var uniqueID = "350125"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinImg: UIImage = UIImage(named: "pinicon")!
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        let pinButton = UIBarButtonItem(image: pinImg, style: UIBarButtonItemStyle.Plain, target: self, action: "pin")
        let rightButtons = [refreshButton, pinButton]
        self.navigationItem.rightBarButtonItems = rightButtons
        self.navigationItem.leftBarButtonItem = logoutButton
        self.title = "On The Map"
    }
    
    func logout() {
        //TODO: destroy current session!
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refresh() {
        //TODO: refresh [Students]
    }
    
    func pin() {
        //TODO: pass necessary info to pin: FirstName, LastName, UserID
        let infoPostingVC = self.storyboard!.instantiateViewControllerWithIdentifier("infoPostingVC") as! InformationPostingViewController
        infoPostingVC.firstName = firstName
        infoPostingVC.lastName = lastName
        infoPostingVC.uniqueID = uniqueID
        presentViewController(infoPostingVC, animated: true, completion: nil)
    }
    

}
