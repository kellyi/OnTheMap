//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/20/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    enum GetStudentLocationsResult {
        case Success([Student])
        case Failure(NSError)
    }
    
    var session: NSURLSession
    let applicationAPIKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    let urlForGetRequest = "https://api.parse.com/1/classes/StudentLocation?limit=100"
    let urlForPostRequest = "https://api.parse.com/1/classes/StudentLocation"
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    // MARK: - Parse API Call Functions
    
    func getStudentLocationsUsingCompletionHandler(completionHandler: (GetStudentLocationsResult) -> (Void)) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlForGetRequest)!)
        request.addValue(applicationAPIKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            var result: GetStudentLocationsResult
            if data == nil {
                result = .Failure(error)
            } else if let response = response as? NSHTTPURLResponse {
                if response.statusCode == 200 {
                    result = self.studentLocationsFromData(data)
                } else {
                    let error = error
                    result = .Failure(error)
                }
            } else {
                let error = error
                result = .Failure(error)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({completionHandler(result)
            })
        })
        task.resume()
    }

    // TODO: Setup completion handler for this!
    func postStudentLocation(uniqueID: String, firstName: String, lastName: String, mediaURL: String, locationString: String, locationLatitude: String, locationLongitude: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlForPostRequest)!)
        request.HTTPMethod = "POST"
        request.addValue(applicationAPIKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueID)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"mapString\": \"\(locationString)\", \"mediaURL\": \"\(mediaURL)\", \"latitude\": \(locationLatitude), \"longitude\": \(locationLongitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
        }
        task.resume()
    }
    
    // MARK: - Functions for Parsing Student Locations
    
    func studentLocationsFromData(data: NSData) -> GetStudentLocationsResult {
        var error: NSError?
        let topLevelDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary?
        if let topLevelDict = topLevelDict {
            let studentsArray = topLevelDict["results"] as! NSArray
            var studentLocations: [Student] = []
            for studentDictionary in studentsArray {
                if let student = studentLocationFromDictionary(studentDictionary as! NSDictionary) {
                    studentLocations.append(student)
                }
            }
            return .Success(studentLocations)
        } else {
            return .Failure(error!)
        }
    }
    
    func studentLocationFromDictionary(studentDictionary: NSDictionary) -> Student? {
        let firstName = studentDictionary["firstName"] as! String
        let lastName = studentDictionary["lastName"] as! String
        let longitude = studentDictionary["longitude"] as! Float
        let latitiude = studentDictionary["latitude"] as! Float
        let mediaURL = studentDictionary["mediaURL"] as! String
        let mapString = studentDictionary["mapString"] as! String
        let objectID = studentDictionary["objectId"] as! String
        let uniqueKey = studentDictionary["uniqueKey"] as! String
        return Student(firstName: firstName, lastName: lastName, longitude: longitude, latitude: latitiude, mediaURL: mediaURL, mapString: mapString, objectID: objectID, uniqueKey: uniqueKey)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}