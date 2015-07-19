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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Set and Juggle UIViews
    
    func setInfoPostingVCViews() {
        // TODO: setup all subviews
        // set buttons to have rounded edges
        // set textfields to have proper padding and placeholder text
    }
    
    func hideURLAndSubmitSubviews(toggle: Bool) {
        // TODO: setup subviews to toggle on/off
        // mapView
        // submitButton
        // urlToShareTextField
        // background views?
        // cancel button?
    }
    
    func hideLocationAndFindOnTheMapSubviews(toggle: Bool) {
        // TODO: setup subviews to toggle on/off
        // findOnTheMapButton
        // locationToShareTextField
        // background views?
        // cancel button?
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
    }
    
    @IBAction func findOnTheMapButtonPressed(sender: UIButton) {
        // TODO: setup
        // toggle URL and Submit Subviews On
        // call function to set locationString to send to Parse
        // call function to set latitude and longitude
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
