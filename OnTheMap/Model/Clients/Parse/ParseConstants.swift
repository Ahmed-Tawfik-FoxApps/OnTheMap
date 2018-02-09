//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/10/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        // MARK: Parse Keys
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Default Values
        static let Limit = 100
        static let OrderBy = "-updatedAt"
        static let Skip = 0

    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let StudentLocation = "/StudentLocation"
        static let AStudentLocation = "/StudentLocation/\(ParseClient.sharedInstance().objectID!)"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let SearchLimit = "limit"
        static let OrderBy = "order"
        static let Skip = "skip"
        static let Where = "where"
    }
    // MARK: Parameter Values
    struct ParameterValues {
        static let UniqueKey = "{\"uniqueKey\":\"\(UdacityClient.sharedInstance().udacityUserLocationInfo.userID)\"}"
    }

    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: IDs
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        
        // MARK: Name
        static let FirstName = "firstName"
        static let LastName = "lastName"
        
        // MARK: Map Information
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
}
