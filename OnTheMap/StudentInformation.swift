//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/8/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation

struct Student {
    let firstName: String
    let lastName: String
    let longitude: Float
    let latitude: Float
    let mediaURL: String
    let mapString: String
    let objectID: String
    let uniqueKey: String
    
    init(initializerDictionary: [String: AnyObject]) {
        self.firstName = initializerDictionary["firstName"] as! String!
        self.lastName = initializerDictionary["lastName"] as! String!
        self.longitude = initializerDictionary["longitude"] as! Float
        self.latitude = initializerDictionary["latitude"] as! Float
        self.mediaURL = initializerDictionary["mediaURL"] as! String!
        self.mapString = initializerDictionary["mapString"] as! String!
        self.objectID = initializerDictionary["objectID"] as! String!
        self.uniqueKey = initializerDictionary["uniqueKey"] as! String!
    }
}