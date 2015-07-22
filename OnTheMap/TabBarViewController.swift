//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Setup Views
    
    // programmatically set navigation bar items
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
    
    // MARK: - Functions for Navigation Bar Actions
    
    // call UdacityClient to destroy session and logout
    func logout() {
        dispatch_async(dispatch_get_main_queue(), {
            UdacityClient.sharedInstance().logoutAndDeleteSession()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    // refresh data for mapview or tableview depending on which is
    // currently active when the button's pressed
    func refresh() {
        if tabBarController?.selectedIndex == 0 {
            let mapVC = self.tabBarController?.viewControllers![0] as! MapViewController
            mapVC.refreshView()
        } else if tabBarController?.selectedIndex == 1 {
            let tableVC = self.tabBarController?.viewControllers![0] as! ListTableViewController
            tableVC.refreshView()
        }
    }
    
    // modally present infoPostingVC
    func pin() {
        let infoPostingVC = self.storyboard!.instantiateViewControllerWithIdentifier("infoPostingVC") as! InformationPostingViewController
        presentViewController(infoPostingVC, animated: true, completion: nil)
    }
}
