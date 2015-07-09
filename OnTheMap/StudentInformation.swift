//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/8/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation

struct StudentInformation {
    let objectID: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: NSDate
    let updatedAt: NSDate
    let ACL: String
    
    init(params: [String:AnyObject]) {
        self.objectID = params["objectID"] as! String
        self.uniqueKey = params["uniqueKey"] as! String
        self.firstName = params["firstName"] as! String
        self.lastName = params["lastName"] as! String
        self.mapString = params["mapString"] as! String
        self.mediaURL = params["mediaURL"] as! String
        self.latitude = params["latitude"] as! Float
        self.longitude = params["longitude"] as! Float
        self.createdAt = params["createdAt"] as! NSDate
        self.updatedAt = params["updatedAt"] as! NSDate
        self.ACL = params["ACL"] as! String
    }
}