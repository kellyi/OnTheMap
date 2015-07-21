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
        UdacityClient.sharedInstance().login(u, password: p)
        nextViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loginButton.enabled = true
        loginActivityIndicator.hidden = true
        let userNamePaddingView = UIView(frame: CGRectMake(0, 0, 20, self.usernameString.frame.height))
        let passwordPaddingView = UIView(frame: CGRectMake(0, 0, 20, self.passwordString.frame.height))
        usernameString.leftView = userNamePaddingView
        passwordString.leftView = passwordPaddingView
        usernameString.leftViewMode = UITextFieldViewMode.Always
        passwordString.leftViewMode = UITextFieldViewMode.Always
        usernameString.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordString.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func nextViewController() {
        let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier("rootNavVC") as! UINavigationController
        presentViewController(rootNavVC, animated: true, completion: nil)
    }
    
    func addSpinner() {
        loginButton.enabled = false
        loginActivityIndicator.hidden = false
        loginActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        loginActivityIndicator.startAnimating()
    }
    
    @IBAction func signupButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
}
