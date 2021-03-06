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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Set and Toggle Views
    
    // set views and hide uiactivityindicator
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loginActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        removeSpinner()
        setTextFieldStyles()
    }
    
    // style username and password textfields
    func setTextFieldStyles() {
        let userNamePaddingView = UIView(frame: CGRectMake(0, 0, 20, self.usernameString.frame.height))
        let passwordPaddingView = UIView(frame: CGRectMake(0, 0, 20, self.passwordString.frame.height))
        usernameString.text = ""
        passwordString.text = ""
        usernameString.leftView = userNamePaddingView
        passwordString.leftView = passwordPaddingView
        usernameString.leftViewMode = UITextFieldViewMode.Always
        passwordString.leftViewMode = UITextFieldViewMode.Always
        usernameString.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordString.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    // show an alert if user tries to login with an empty email address or password
    func textFieldIsEmpty(emptyTextField: String) {
        var emptyStringAlert = UIAlertController(title: "Please enter your \(emptyTextField)", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        emptyStringAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(emptyStringAlert, animated: true, completion: nil)
        return
    }
    
    // convenience method for toggling controls on and off
    func toggleButtonsAndTextFields(onOff: String) {
        onOff == "on" ?  removeSpinner() : addSpinner()
    }
    
    // show UIActivityIndicator
    func addSpinner() {
        enableAndDisableButtonsAndTextFields("disable")
        loginActivityIndicator.hidden = false
        loginActivityIndicator.startAnimating()
    }
    
    // hide UIActivityIndicator
    func removeSpinner() {
        enableAndDisableButtonsAndTextFields("enable")
        loginActivityIndicator.stopAnimating()
        loginActivityIndicator.hidden = true
    }
    
    // toggle controls on and off
    func enableAndDisableButtonsAndTextFields(enableDisable: String) {
        let disabledBool = enableDisable == "enable" ? true : false
        loginButton.enabled = disabledBool
        signUpButton.enabled = disabledBool
        usernameString.enabled = disabledBool
        passwordString.enabled = disabledBool
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        login()
    }
    
    @IBAction func signupButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    // MARK: - Login Functions
    
    // attempt to login with UdacityClient and user-supplied credentials
    func login() {
        if usernameString.text.isEmpty {
            textFieldIsEmpty("email address")
        } else if passwordString.text.isEmpty {
           textFieldIsEmpty("password")
        } else {
            addSpinner()
            UdacityClient.sharedInstance().username = usernameString.text
            UdacityClient.sharedInstance().password = passwordString.text
            UdacityClient.sharedInstance().loginAndCreateSession() { (success, errorString) in
                if success {
                    self.completeLogin()
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.removeSpinner()
                        var errorAlert = UIAlertController(title: errorString!, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    // finish login if UdacityClient API call was successful
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.removeSpinner()
            let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier("rootNavVC") as! UINavigationController
            self.presentViewController(rootNavVC, animated: true, completion: nil)
        })
    }
}
