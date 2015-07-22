//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/19/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    // values to be passed in from the existing Udacity session
    var firstName: String = UdacityClient.sharedInstance().userFirstName
    var lastName: String = UdacityClient.sharedInstance().userLastName
    var uniqueID: String = UdacityClient.sharedInstance().uniqueID
    
    // variables to be set from user input
    var locationString: String = ""
    var locationLatitude: String = ""
    var locationLongitude: String = ""
    var mediaURL: String = ""
    
    @IBOutlet weak var apiCallActivityIndicator: UIActivityIndicatorView!
    
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
    
    // set keyboard handling
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.shareURLTextField.delegate = self
        self.findOnTheMapTextField.delegate = self
    }
    
    // setup all subviews, then show first set of subviews
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        removeSpinner()
        setInfoPostingVCSubviews()
        showFindOnTheMapSubviews()
    }
    
    // MARK: - Set and Toggle UIViews
    
    // set subviews
    func setInfoPostingVCSubviews() {
        // give button rounded edges
        findOnMapAndSubmitButton.layer.cornerRadius = 10
        
        // set placeholder text and other attributes for UITextFields
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
    
    func addSpinner() {
        apiCallActivityIndicator.startAnimating()
        apiCallActivityIndicator.hidden = false
    }
    
    func removeSpinner() {
        apiCallActivityIndicator.stopAnimating()
        apiCallActivityIndicator.hidden = true
    }
    
    // show second set of subviews
    func showFindOnTheMapSubviews() {
        // set attributes for shared subviews
        findOnMapAndSubmitButton.setTitle("Find on the Map", forState: .Normal)
        cancelButton.setTitleColor(UIColor.ocean(), forState: .Normal)
        topViewContainer.backgroundColor = UIColor.silver()
        apiCallActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        
        // show first group subviews
        middleViewContainer.hidden = false
        findOnTheMapTextField.hidden = false
        whereAreYouLabel.hidden = false
        studyingLabel.hidden = false
        todayLabel.hidden = false
        
        // hide second group subviews
        shareURLTextField.hidden = true
        infoVCMapView.hidden = true
    }
    
    // show only second set of subviews
    func showSubmitSubviews() {
        // set attributes for shared subviews
        findOnMapAndSubmitButton.setTitle("Submit", forState: .Normal)
        cancelButton.setTitleColor(UIColor.silver(), forState: .Normal)
        topViewContainer.backgroundColor = UIColor.ocean()
        apiCallActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        // hide first group subviews
        middleViewContainer.hidden = true
        findOnTheMapTextField.hidden = true
        whereAreYouLabel.hidden = true
        studyingLabel.hidden = true
        todayLabel.hidden = true
        
        // show second group subviews
        shareURLTextField.hidden = false
        infoVCMapView.hidden = false
    }
    
    // MARK: - IBActions
    
    // call different function based on button titleLabel
    @IBAction func findOnTheMapAndSubmitButtonPressed(sender: UIButton) {
        // route action depending on button state
        if findOnMapAndSubmitButton.titleLabel?.text == "Find on the Map" {
            findOnTheMapButtonPressed()
        } else {
            submitButtonPressed()
        }
    }
    
    // "Find on the Map" button pressed actions
    func findOnTheMapButtonPressed() {
        if findOnTheMapTextField.text.isEmpty {
            // show an alert if the UITextField doesn't have a value
            var emptyStringAlert = UIAlertController(title: "Please enter your location", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            emptyStringAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(emptyStringAlert, animated: true, completion: nil)
            return
        } else {
            // set locationString class variable
            // call function to geocode the locationString
            // transition from first subview group to second subview group
            locationString = findOnTheMapTextField.text
            getLatitudeAndLongitudeFromString(locationString)
        }
    }
    
    // "Submit" button pressed actions
    func submitButtonPressed() {
        if shareURLTextField.text.isEmpty {
            var emptyStringAlert = UIAlertController(title: "Please enter a link to share", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            emptyStringAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(emptyStringAlert, animated: true, completion: nil)
            return
        } else {
            addSpinner()
            mediaURL = shareURLTextField.text
            ParseClient.sharedInstance().postStudentLocation(uniqueID, firstName: firstName, lastName: lastName, mediaURL: mediaURL, locationString: locationString, locationLatitude: locationLatitude, locationLongitude: locationLongitude) { (success, errorString) in
                if success {
                    self.removeSpinner()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    self.removeSpinner()
                    dispatch_async(dispatch_get_main_queue(), {
                        var errorAlert = UIAlertController(title: errorString!, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                    })
                }
            }
        }
        
    }
    
    // cancel button pressed action
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Location Stuff
    
    // geocode the locationstring to return a CLLocationCoordinate2D object
    func getLatitudeAndLongitudeFromString(location: String) {
        addSpinner()
        var geocoder = CLGeocoder()
        var latitudeFromString: Double?
        var longitudeFromString: Double?
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.infoVCMapView.addAnnotation(MKPlacemark(placemark: placemark))
                let locationCoordinate = placemark.location.coordinate as CLLocationCoordinate2D
                self.setMapViewRegionAndScale(locationCoordinate)
                self.removeSpinner()
                self.showSubmitSubviews()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.removeSpinner()
                    var errorAlert = UIAlertController(title: "Couldn't geocode your location", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    errorAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                })
            }
        })
    }
    
    // center map and zoom in on user-entered location
    func setMapViewRegionAndScale(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.13, 0.13)
        let region = MKCoordinateRegion(center: location, span: span)
        infoVCMapView.setRegion(region, animated: true)
        locationLatitude = "\(location.latitude)"
        locationLongitude = "\(location.longitude)"
    }
    
    // MARK: - Keyboard Handling
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - Add Silver and Ocean UIColors
extension UIColor {
    
    class func ocean() -> UIColor {
        return UIColor(red:0/255, green:64/255, blue:128/255, alpha:1.0)
    }
    
    class func silver() -> UIColor {
        return UIColor(red:204/255, green:204/255, blue:204/255, alpha:1.0)
    }
}

