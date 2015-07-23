//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/20/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: - Constants and Variables
    
    // shared array for student locations
    var studentLocations: [Student] = []
    
    // Parse API keys and urls
    let applicationAPIKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    let urlForGetRequest = "https://api.parse.com/1/classes/StudentLocation?limit=100"
    let urlForPostRequest = "https://api.parse.com/1/classes/StudentLocation"
    
    var session: NSURLSession
    var completionHandler : ((success: Bool, errorString: String?) -> Void)? = nil
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    // MARK: - Parse API Call Functions
    
    // retrieve last 100 students and add them to the studentLocations array
    func getStudentLocationsUsingCompletionHandler(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlForGetRequest)!)
        request.addValue(applicationAPIKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "The internet connection appears to be offline")
            } else {
                var error: NSError?
                let topLevelDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! NSDictionary?
                if let topLevelDict = topLevelDict {
                    let studentsArray = topLevelDict["results"] as! NSArray
                    self.studentLocations = []
                    for studentDictionary in studentsArray {
                        if let student = self.studentLocationFromDictionary(studentDictionary as! NSDictionary) {
                            self.studentLocations.append(student)
                        }
                    }
                }
                completionHandler(success: true, errorString: nil)
            }
        }
        task.resume()
    }

    // post the logged-in user's location
    func postStudentLocation(uniqueID: String, firstName: String, lastName: String, mediaURL: String, locationString: String, locationLatitude: String, locationLongitude: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlForPostRequest)!)
        request.HTTPMethod = "POST"
        request.addValue(applicationAPIKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueID)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"mapString\": \"\(locationString)\", \"mediaURL\": \"\(mediaURL)\", \"latitude\": \(locationLatitude), \"longitude\": \(locationLongitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "The internet connection appears to be offline")
            } else {
                var error: NSError?
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as! NSDictionary
                if parsedResult["createdAt"] != nil {
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "An unknown error occurred")
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Function for Parsing Data into StudentInformation Structs
    
    // convenience method for converting JSON into a Student object
    func studentLocationFromDictionary(studentDictionary: NSDictionary) -> Student? {
        let studentFirstName = studentDictionary["firstName"] as! String
        let studentLastName = studentDictionary["lastName"] as! String
        let studentLongitude = studentDictionary["longitude"] as! Float!
        let studentLatitude = studentDictionary["latitude"] as! Float!
        let studentMediaURL = studentDictionary["mediaURL"] as! String
        let studentMapString = studentDictionary["mapString"] as! String
        let studentObjectID = studentDictionary["objectId"] as! String
        let studentUniqueKey = studentDictionary["uniqueKey"] as! String
        let initializerDictionary = ["firstName": studentFirstName, "lastName": studentLastName, "longitude": studentLongitude, "latitude": studentLatitude, "mediaURL": studentMediaURL, "mapString": studentMapString, "objectID": studentObjectID, "uniqueKey": studentUniqueKey]
        return Student(initializerDictionary: initializerDictionary as! [String:AnyObject])
    }
    
    // MARK: - Shared Instance
    
    // make this class a singleton to share across classes
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}