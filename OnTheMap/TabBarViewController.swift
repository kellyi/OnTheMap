//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refresh() {
        println("refresh")
    }
    
    func pin() {
        let infoPostingVC = self.storyboard!.instantiateViewControllerWithIdentifier("infoPostingVC") as! PostingViewController
        presentViewController(infoPostingVC, animated: true, completion: nil)
    }
    

}
