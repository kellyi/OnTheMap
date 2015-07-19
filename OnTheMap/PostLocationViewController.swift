//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        findOnTheMapButton.hidden = false
        locationTextField.hidden = false
        let locationPaddingView = UIView(frame: CGRectMake(0, 0, 20, self.locationTextField.frame.height))
        locationTextField.leftView = locationPaddingView
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    @IBAction func dismissPostingViewController(sender: UIButton) {
        //StudentLocations.postStudentLocation
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postingButtonPressed(sender: UIButton) {
        println(locationTextField.text)
        //TODO: turn string into CLLocation
    }

}
