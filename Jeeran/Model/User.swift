//
//  User.swift
//  Jeeran
//
//  Created by Mohammed on 6/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class User : NSCoder, Mappable {

    var userId : Int!
    var firstName : String!
    var lastName : String!
    var email : String!
    var imageUrl : String!
    var dateOfBirth : String!
    var facebookId : String!
    var mobileNumber : String!
    var neighborhoodId : Int!
    var neighborhood_ar : String!
    var neighborhood_en : String!
    var language : Int!
    var deviceToken : String!
    var deviceType : Int!
    var token : String!
    
    func encodeWithCoder(encoder : NSCoder) {
        encoder.encodeInteger(self.userId, forKey: "userId")
        encoder.encodeObject(self.firstName, forKey: "firstName")
        encoder.encodeObject(self.lastName, forKey: "lastName")
        encoder.encodeObject(self.email, forKey: "email")
        encoder.encodeObject(self.imageUrl, forKey: "imageUrl")
        encoder.encodeObject(self.dateOfBirth, forKey: "dateOfBirth")
        encoder.encodeObject(self.facebookId, forKey: "facebookId")
        encoder.encodeObject(self.mobileNumber, forKey: "mobileNumber")
        encoder.encodeInteger(self.neighborhoodId, forKey: "neighborhoodId")
        encoder.encodeObject(self.neighborhood_ar, forKey: "neighborhood_ar")
        encoder.encodeObject(self.neighborhood_en, forKey: "neighborhood_en")
        encoder.encodeInteger(self.language, forKey: "language")
        encoder.encodeObject(self.deviceToken, forKey: "deviceToken")
        encoder.encodeInteger(self.deviceType, forKey: "deviceType")
        encoder.encodeObject(self.token, forKey: "token")
    }
    
    func initWithCoder(decoder : NSCoder) -> AnyObject {
        self.userId = decoder.decodeIntegerForKey("userId")
        self.firstName = decoder.decodeObjectForKey("firstName") as! String
        self.lastName = decoder.decodeObjectForKey("lastName") as! String
        self.email = decoder.decodeObjectForKey("email") as! String
        self.imageUrl = decoder.decodeObjectForKey("imageUrl") as! String
        self.dateOfBirth = decoder.decodeObjectForKey("dateOfBirth") as! String
        self.facebookId = decoder.decodeObjectForKey("facebookId") as! String
        self.mobileNumber = decoder.decodeObjectForKey("mobileNumber") as! String
        self.neighborhoodId = decoder.decodeIntegerForKey("neighborhoodId")
        self.neighborhood_ar = decoder.decodeObjectForKey("neighborhood_ar") as! String
        self.neighborhood_en = decoder.decodeObjectForKey("neighborhood_en") as! String
        self.language = decoder.decodeIntegerForKey("language")
        self.deviceToken = decoder.decodeObjectForKey("deviceToken") as! String
        self.deviceType = decoder.decodeIntegerForKey("deviceType")
        self.token = decoder.decodeObjectForKey("token") as! String
        
        return self
    }

    required init?(_ map: Map) {
        
    }

    
    func mapping(map: Map) {
        self.userId <- map["user_id"]
        self.firstName <- map["fName"]
        self.lastName <- map["lName"]
        self.email <- map["mail"]
        self.imageUrl <- map["image"]
        self.dateOfBirth <- map["dateOfBirth"]
        self.facebookId <- map["fb_id"]
        self.mobileNumber <- map["mobile_number"]
        self.neighborhoodId <- map["neighborhood_id"]
        self.neighborhood_ar <- map["neighborhood_ar"]
        self.neighborhood_en <- map["neighborhood_en"]
        self.language <- map["lang"]
        self.deviceToken <- map["device_token"]
        self.deviceType <- map["device_type"]
//        self.token <- map["token"]
    }
}