//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit

class PostingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissPostingViewController(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
