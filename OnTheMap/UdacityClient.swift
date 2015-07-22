//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/18/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient: NSObject {
    
    var username: String = ""
    var password: String = ""
    var sessionID: String = ""
    var uniqueID: String = "u21415045"
    var userFirstName: String = ""
    var userLastName: String = ""
    
    var session: NSURLSession
    var completionHandler : ((success: Bool, errorString: String?) -> Void)? = nil
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
        
    func loginAndCreateSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "No internet connection")
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            if let errorMessage = parsedResult["error"] as? String {
                completionHandler(success: false, errorString: errorMessage)
            } else {
                if let registered = parsedResult["account"] as? NSDictionary {
                    self.uniqueID = registered["key"] as! String
                    self.getUserData()
                }
                if let sessionID = parsedResult["session"] as? NSDictionary {
                    self.sessionID = sessionID["id"] as! String
                }
                completionHandler(success: true, errorString: nil)
            }
        }
        task.resume()
    }
    
    func logoutAndDeleteSession() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    func getUserData() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(uniqueID)")!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            if let user = parsedResult["user"] as? NSDictionary {
                self.userFirstName = user["first_name"] as! String
                self.userLastName = user["last_name"] as! String
            }
        }
        task.resume()
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}