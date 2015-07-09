//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let names = ["Alice","Brad","Candace","David","Ethyl","Francis","Gigi","Herod","Ines","Jack"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameCell") as! UITableViewCell
        var image: UIImage = UIImage(named: "pinicon")!
        cell.imageView!.image = image
        cell.textLabel!.text = names[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://udacity.com")!)
    }

}
