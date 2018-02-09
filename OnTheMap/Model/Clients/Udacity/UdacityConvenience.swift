//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/8/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    func loginWithEmailAndPassword(email: String, password: String, completionHandlerForLogIn: @escaping (_ success: Bool, _ errorString: String?) -> Void ) {
        postUdacitySession(email: email, password: password) { (success, userID, errorString) in
            if success {
                self.udacityUserLocationInfo.userID = userID!
                self.getPublicUserData(userID: userID) { (success, firstName, lastName, errorString) in
                    if success {
                        self.udacityUserLocationInfo.firstName = firstName!
                        self.udacityUserLocationInfo.lastName = lastName!
                    }
                    completionHandlerForLogIn(success, errorString)
                }
            } else {
                completionHandlerForLogIn(success, errorString)
            }
        }
    }
    
    func postUdacitySession(email: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ userID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        let method = Methods.Session
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForSession(false, nil, "Login Failed.")
            } else {
                if let results = results as? [String: AnyObject],
                    let  account = results["account"] as? [String: AnyObject],
                    let userIsRegistered = account["registered"] as? Bool,
                    let userID = account["key"] as? String {
                    if userIsRegistered {
                    completionHandlerForSession(true, userID, nil)
                    }
                } else {
                    completionHandlerForSession(false, nil, "Login Failed")
                }
            }
        }
    }
    
    func getPublicUserData (userID: String?, completionHandlerForUserData: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        var method = Methods.User
        method = substituteKeyInMethod(method, key: URLKeys.UserID, value: udacityUserLocationInfo.userID)!
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method, parameters: parameters) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUserData(false, nil, nil, "User is not found.")
            } else {
                if let results = results as? [String: AnyObject],
                    let  user = results["user"] as? [String: AnyObject],
                    let firstName = user["first_name"] as? String,
                    let lastName = user["last_name"] as? String {
                    completionHandlerForUserData(true, firstName, lastName, nil)
                } else {
                    completionHandlerForUserData(false, nil, nil, "User is not found")
                }
            }
        }
    }
    
    func deleteSession (completionHandlerForDeleteSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        let method = Methods.Session
        
        /* 2. Make the request */
        let _ = taskForDELETEMethod(method, parameters: parameters) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForDeleteSession(false, "Logout Failed.")
            } else {
                if let _ = results as? [String: AnyObject] {
                    completionHandlerForDeleteSession(true, nil)
                } else {
                    completionHandlerForDeleteSession(false, "Logout Failed")
                }
            }
        }

    }
}
