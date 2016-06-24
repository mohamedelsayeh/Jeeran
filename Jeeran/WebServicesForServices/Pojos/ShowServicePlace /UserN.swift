//
//  User.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class UserN: Mappable {
    var user_id:Int?
    var is_active: Int?
    var first_name: String?
    var last_name: String?
    var email: String?
    var image: String?
    var date_of_birth: String?
    var mobile_number: String?
    var last_forget_password : String?
    var verify_email : String?
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        is_active <- map["is_active"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        image <- map["image"]
        date_of_birth <- map["date_of_birth"]
        mobile_number <- map["mobile_number"]
        last_forget_password <- map["last_forget_password"]
        verify_email <- map["verify_email"]
    }
}