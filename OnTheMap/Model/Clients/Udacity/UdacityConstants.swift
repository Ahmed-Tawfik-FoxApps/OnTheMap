//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 10/8/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }

    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Session = "/session"
        static let User = "/users/{id}"
    }

}
