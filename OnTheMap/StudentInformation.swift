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
    let latutide: Float
    let mediaURL: String
    let mapString: String
    let objectID: String
    let uniqueKey: String
    
    init(firstName: String, lastName: String, longitude: Float, latitude: Float, mediaURL: String, mapString: String, objectID: String, uniqueKey: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.longitude = longitude
        self.latutide = latitude
        self.mediaURL = mediaURL
        self.mapString = mapString
        self.objectID = objectID
        self.uniqueKey = uniqueKey
    }
}