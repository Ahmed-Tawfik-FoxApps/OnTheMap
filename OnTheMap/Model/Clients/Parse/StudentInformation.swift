//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/10/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import Foundation
struct StudentInformation {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    
    // MARK: Initializers
    // construct a StudenLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String ?? ""
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String ?? ""
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String ?? ""
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String ?? ""
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String ?? ""
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double ?? 0.0
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double ?? 0.0
    }
    
    static func studentInformationFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var studentInformation = [StudentInformation]()
        
        for result in results {
            studentInformation.append(StudentInformation(dictionary: result))
        }
        return studentInformation
    }
}
