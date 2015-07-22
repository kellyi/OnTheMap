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
    var uniqueID: String = ""
    
    var session: NSURLSession
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    func loginAndCreateSession() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println(error)
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            //println(NSString(data: newData, encoding: NSUTF8StringEncoding)!)
            //TODO:
            // 1. parse JSON
            // 2. check whether "registered" == true
            // 3. if so, present "rootNavVC", passing it the sessionID and the Key
            // 4. if not, UIActivityView error message explaining what went wrong
            // 5. also: spinner to disable view while API call's being made
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            if let registered = parsedResult["account"] as? NSDictionary {
                println(registered["key"])
                
            }
            if let sessionID = parsedResult["session"] as? NSDictionary {
                println(sessionID["id"])
            }
            if let errorMessage = parsedResult["error"] as? String {
                println(errorMessage)
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
    
    func getUserData(uniqueID: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(uniqueID)")!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}