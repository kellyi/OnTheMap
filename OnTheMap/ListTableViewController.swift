//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let studentLocations = StudentLocations()
    var students: [Student] = []
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        populateTableView()
    }
    
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
        println("\(student.mediaURL)")
        //UIApplication.sharedApplication().openURL(NSURL(string: "http://udacity.com")!)
    }
    
    func populateTableView() {
        studentLocations.getStudentLocationsUsingCompletionHandler() { (result) in
            switch result {
            case .Success(let students):
                self.students = students
                self.studentsTableView.reloadData()
            case .Failure(let error):
                self.students = []
                println(error)
            }
        }
    }
}
