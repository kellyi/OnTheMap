//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/13/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation

class StudentLocations {
    
    enum GetStudentLocationsResult {
        case Success([Student])
        case Failure(NSError)
    }
    
    let session: NSURLSession
    
    init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
    }
    
    func getStudentLocationsUsingCompletionHandler(completionHandler: (GetStudentLocationsResult) -> (Void)) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
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
        return Student(firstName: firstName, lastName: lastName, longitude: longitude, latitude: latitiude, mediaURL: mediaURL)
    }
}