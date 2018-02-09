//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/10/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import Foundation
import CoreLocation

extension ParseClient {
    
    func getStudentInformation(limit: Int = Constants.Limit, orderBy: String = Constants.OrderBy, skip: Int = Constants.Skip,completionHandlerForGetStudentInformation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [ParameterKeys.SearchLimit: limit as AnyObject,
                          ParameterKeys.Skip: skip as AnyObject,
                          ParameterKeys.OrderBy: orderBy as AnyObject]
        let method = Methods.StudentLocation
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method, parameters: parameters) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGetStudentInformation(false, "Downloading Data Failed.")
            } else {
                if let results = results!["results"] as? [[String:AnyObject]] {
                    let studentInformation = StudentInformation.studentInformationFromResults(results)
                    StudentInformationModel.sharedInstance().studentInformation = studentInformation
                    completionHandlerForGetStudentInformation(true, nil)
                } else {
                    completionHandlerForGetStudentInformation(false, "Downloading Data Failed.")
                }
            }
        }
    }
    
    func userHasRecordInDB (completionHandlerForHasRecordInDB: @escaping (_ success: Bool, _ userHasRecord: Bool,_ errorString: String?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [ParameterKeys.Where: ParameterValues.UniqueKey as AnyObject]
        let method = Methods.StudentLocation
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method, parameters: parameters) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForHasRecordInDB(false, false, "Couldn't verify the User.")
            } else {
                if let results = results!["results"] as? [[String:AnyObject]] {
                    if results.count != 0 {
                        if let objectID = results[0]["objectId"] as? String {
                            self.objectID = objectID
                            completionHandlerForHasRecordInDB(true, true, nil)
                        } else {
                        completionHandlerForHasRecordInDB(true, false, nil)
                        }
                    } else {
                        completionHandlerForHasRecordInDB(true, false, nil)
                    }
                } else {
                    completionHandlerForHasRecordInDB(false, false, "Couldn't verify the User.")
                }
            }
        }
    }
    
    func submitStudentLocation (udacitUserLocationInfo: UdacityUser, placeMark: CLPlacemark ,completionHandlerForsubmitStudentLocation: @escaping (_ success: Bool,_ errorString: String?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method: String?
        let httpMethod: String?
        if udacitUserLocationInfo.userHasRecord {
            method = Methods.AStudentLocation
            httpMethod = "PUT"
        } else {
            method = Methods.StudentLocation
            httpMethod = "POST"
        }
        let jsonBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().udacityUserLocationInfo.userID)\", \"firstName\": \"\(udacitUserLocationInfo.firstName)\", \"lastName\": \"\(udacitUserLocationInfo.lastName)\",\"mapString\": \"\(placeMark.name!)\", \"mediaURL\": \"\(udacitUserLocationInfo.mediaURL)\",\"latitude\": \((placeMark.location?.coordinate.latitude)!), \"longitude\": \((placeMark.location?.coordinate.longitude)!)}"
        
        /* 2. Make the request */
        let _ = taskForPOSTAndPUTMethods(method!, httpMethod: httpMethod!, jsonBody: jsonBody) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForsubmitStudentLocation(false, "Posting Student Information Failed.")
            } else {
                if let _ = results {
                        completionHandlerForsubmitStudentLocation(true, nil)
                } else {
                    completionHandlerForsubmitStudentLocation(false, "Posting Student Information Failed")
                }
            }
        }
    }
}
