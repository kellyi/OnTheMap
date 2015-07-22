//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var students: [Student] = ParseClient.sharedInstance().studentLocations
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    @IBOutlet weak var tableDataActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Setup and Handle Views
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableDataActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        addSpinner()
        populateTableView()
    }
    
    func addSpinner() {
        tableDataActivityIndicator.startAnimating()
        tableDataActivityIndicator.hidden = false
    }
    
    func removeSpinner() {
        tableDataActivityIndicator.stopAnimating()
        tableDataActivityIndicator.hidden = true
    }
    
    // MARK: - TableView Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameCell") as! UITableViewCell
        var image: UIImage = UIImage(named: "pinicon")!
        cell.imageView!.image = image
        let student = students[indexPath.row]
        cell.textLabel!.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel!.text = "\(student.mapString)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = students[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL)!)
    }
    
    // retrieve results from Parse API
    func populateTableView() {
        ParseClient.sharedInstance().getStudentLocationsUsingCompletionHandler() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.removeSpinner()
                    self.students = ParseClient.sharedInstance().studentLocations
                    self.studentsTableView.reloadData()
                })
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
    
    // MARK: - Generic Method to Refresh Data
    
    // called from TabBarViewController's refresh button
    func refreshView() {
        populateTableView()
    }
}
