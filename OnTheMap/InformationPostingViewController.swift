//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/19/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate {

    // should take firstname/lastname/udacity ID at the start from udacity API
    // set as constant here
    
    @IBOutlet weak var shareURLTextField: UITextField!
    
    @IBOutlet weak var findOnTheMapTextField: UITextField!
    
    // MARK: - View Outlets for Toggling
    
    
    // shareURLSubviews
    @IBOutlet weak var infoVCMapView: MKMapView!
    @IBOutlet weak var shareURLTopContainer: UIView!
    @IBOutlet weak var shareURLCancelButton: UIButton!
    @IBOutlet weak var shareURLSubmitButtonContainer: UIView!
    @IBOutlet weak var shareURLSubmitButton: UIButton!
    
    // findOnTheMapSubviews
    @IBOutlet weak var whereAreYouLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var findOnTheMapCancelButton: UIButton!
    @IBOutlet weak var findOnTheMapTopContainer: UIView!
    @IBOutlet weak var findOnTheMapMiddleContainer: UIView!
    @IBOutlet weak var findOnTheMapBottomContainer: UIView!
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setInfoPostingVCViews()
        toggleShareURLSubviews("off")
        toggleFindOnTheMapSubviews("on")
    }
    
    // MARK: - Set and Toggle UIViews
    
    func setInfoPostingVCViews() {
        // TODO: setup all subviews
        // set buttons to have rounded edges
        findOnTheMapButton.layer.cornerRadius = 10
        shareURLSubmitButton.layer.cornerRadius = 10
        
        // set textfields to have proper padding and placeholder text
        let findOnTheMapTextFieldPaddingView = UIView(frame: CGRectMake(0, 0, 20, self.findOnTheMapTextField.frame.height))
        findOnTheMapTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        let shareURLTextFieldPaddingView = UIView(frame: CGRectMake(0, 0, 20, self.shareURLTextField.frame.height))
        shareURLTextField.attributedPlaceholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func toggleShareURLSubviews(onOff: String) {
        let hiddenBoolValue = onOff == "on" ? false : true
        shareURLTextField.hidden = hiddenBoolValue
        shareURLTopContainer.hidden = hiddenBoolValue
        shareURLCancelButton.hidden = hiddenBoolValue
        shareURLSubmitButtonContainer.hidden = hiddenBoolValue
        shareURLSubmitButton.hidden = hiddenBoolValue
        infoVCMapView.hidden = hiddenBoolValue
    }
    
    func toggleFindOnTheMapSubviews(onOff: String) {
        let hiddenBoolValue = onOff == "on" ? false : true
        findOnTheMapTextField.hidden = hiddenBoolValue
        whereAreYouLabel.hidden = hiddenBoolValue
        studyingLabel.hidden = hiddenBoolValue
        todayLabel.hidden = hiddenBoolValue
        findOnTheMapCancelButton.hidden = hiddenBoolValue
        findOnTheMapTopContainer.hidden = hiddenBoolValue
        findOnTheMapMiddleContainer.hidden = hiddenBoolValue
        findOnTheMapButton.hidden = hiddenBoolValue
    }
    
    func setMapViewRegionAndScale() {
        // TODO: Setup
        // this should use class level latitude and longitude variables
        // to set the region and scale of the map
    }
    
    // MARK: - IBActions
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        //TODO: setup
        //post info to parse:
        //locationstring
        //latitude, longitude
        //firstname, lastname
        //mediaURL
        //udacityID
        //?
        //dismiss the viewcontroller in some way
        println("submit button pressed")
    }
    
    @IBAction func findOnTheMapButtonPressed(sender: UIButton) {
        // TODO: setup
        // toggle URL and Submit Subviews On
        // call function to set locationString to send to Parse
        // call function to set latitude and longitude
        toggleFindOnTheMapSubviews("off")
        toggleShareURLSubviews("on")
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Location Stuff
    
    func getLatitudeAndLongitudeFromString(location: String) {
        //TODO: setup
        // this function should get the latitude and longitude for a string
        // it should set all three as class level variables
    }

}
