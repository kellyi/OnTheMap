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
    var locationString: String = ""
    var locationLatitude: Double?
    var locationLongitude: Double?
    
    // UITextFields
    @IBOutlet weak var shareURLTextField: UITextField!
    @IBOutlet weak var findOnTheMapTextField: UITextField!
    
    // MARK: - View Outlets for Toggling
    @IBOutlet weak var infoVCMapView: MKMapView!
    @IBOutlet weak var topViewContainer: UIView!
    @IBOutlet weak var middleViewContainer: UIView!
    @IBOutlet weak var bottomViewContainer: UIView!
    @IBOutlet weak var findOnMapAndSubmitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setInfoPostingVCSubViews()
        showFindOnTheMapSubviews()
    }
    
    // MARK: - Set and Toggle UIViews
    
    func setInfoPostingVCSubViews() {
        findOnMapAndSubmitButton.layer.cornerRadius = 10
        
        // set textfields to have proper padding and placeholder text
        let findOnTheMapTextFieldPaddingView = UIView(frame: CGRectMake(0, 0, 20, self.findOnTheMapTextField.frame.height))
        findOnTheMapTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSForegroundColorAttributeName: UIColor.silver()])
        findOnTheMapTextField.leftViewMode = UITextFieldViewMode.Always
        let shareURLTextFieldPaddingView = UIView(frame: CGRectMake(0, 0, 20, self.shareURLTextField.frame.height))
        shareURLTextField.attributedPlaceholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: [NSForegroundColorAttributeName: UIColor.silver()])
        shareURLTextField.leftViewMode = UITextFieldViewMode.Always
        
        // set label textColors
        whereAreYouLabel.textColor = UIColor.ocean()
        studyingLabel.textColor = UIColor.ocean()
        todayLabel.textColor = UIColor.ocean()
    }
    
    func showFindOnTheMapSubviews() {
        findOnMapAndSubmitButton.setTitle("Find on the Map", forState: .Normal)
        cancelButton.setTitleColor(UIColor.ocean(), forState: .Normal)
        topViewContainer.backgroundColor = UIColor.silver()
        
        middleViewContainer.hidden = false
        shareURLTextField.hidden = true
        findOnTheMapTextField.hidden = false
        whereAreYouLabel.hidden = false
        studyingLabel.hidden = false
        todayLabel.hidden = false
        infoVCMapView.hidden = true
    }
    
    func showSubmitSubviews() {
        findOnMapAndSubmitButton.setTitle("Submit", forState: .Normal)
        cancelButton.setTitleColor(UIColor.silver(), forState: .Normal)
        topViewContainer.backgroundColor = UIColor.ocean()
        
        middleViewContainer.hidden = true
        shareURLTextField.hidden = false
        findOnTheMapTextField.hidden = true
        whereAreYouLabel.hidden = true
        studyingLabel.hidden = true
        todayLabel.hidden = true
        infoVCMapView.hidden = false
        
        println(locationString)
    }
    
    // MARK: - IBActions
    
    @IBAction func findOnTheMapAndSubmitButtonPressed(sender: UIButton) {
        if findOnMapAndSubmitButton.titleLabel?.text == "Find on the Map" {
            findOnTheMapButtonPressed()
        } else {
            submitButtonPressed()
        }
    }
    
    func findOnTheMapButtonPressed() {
        // TODO: setup
        
        // get longitude and latitude from string
        // set longitude and latitude
        // set map on proper region and scale
        // show next set of subviews
        println("find on the map button pressed")
        let location = findOnTheMapTextField.text
        locationString = location
        getLatitudeAndLongitudeFromString(location)
        showSubmitSubviews()
    }
    
    func submitButtonPressed() {
        // TODO: setup
        // set url to a string
        // pass all necessary info as a post request to Parse
        // dismiss this viewController
        println("submit button pressed")
        showFindOnTheMapSubviews()
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Location Stuff
    
    func getLatitudeAndLongitudeFromString(location: String) {
        var geocoder = CLGeocoder()
        var latitudeFromString: Double?
        var longitudeFromString: Double?
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.infoVCMapView.addAnnotation(MKPlacemark(placemark: placemark))
                let locationCoordinate = placemark.location.coordinate as CLLocationCoordinate2D
                self.setMapViewRegionAndScale(locationCoordinate)
            }
        })
    }
    
    func setMapViewRegionAndScale(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.13, 0.13)
        let region = MKCoordinateRegion(center: location, span: span)
        infoVCMapView.setRegion(region, animated: true)
        locationLatitude = location.latitude
        locationLongitude = location.longitude
        println(locationLatitude)
        println(locationLongitude)
    }
}

extension UIColor {
    
    class func ocean() -> UIColor {
        return UIColor(red:0/255, green:64/255, blue:128/255, alpha:1.0)
    }
    
    class func silver() -> UIColor {
        return UIColor(red:204/255, green:204/255, blue:204/255, alpha:1.0)
    }
}

