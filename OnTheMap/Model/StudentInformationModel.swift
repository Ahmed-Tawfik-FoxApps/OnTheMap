//
//  StudentInformationModel.swift
//  OnTheMap
//
//  Created by Ahmed Tawfik on 12/8/17.
//  Copyright © 2017 Fox Apps. All rights reserved.
//

import Foundation


class StudentInformationModel {
    
    //MARK: Variables
    var studentInformation = [StudentInformation]()
    
    // MARK: Shared Instance
    class func sharedInstance() -> StudentInformationModel {
        struct Singleton {
            static var sharedInstance = StudentInformationModel()
        }
        return Singleton.sharedInstance
    }

}
