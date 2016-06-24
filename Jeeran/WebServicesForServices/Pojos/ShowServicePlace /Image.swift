//
//  image.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class Image: Mappable {
    // misssing rate Attrubute
    var service_place_review_id:Int?
    var review: String?
    var is_hide: Int?
    var created_at: String?
    var updated_at: Int?
    var service_place_id: Int?
    var user_id: Int?
    var rating: Int?
    var user : UserN?
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        service_place_review_id <- map["service_place_review_id"]
        review <- map["title"]
        is_hide <- map["is_hide"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        service_place_id <- map["service_place_id"]
        user_id <- map["user_id"]
        rating <- map["rating"]
        user <- map["user"]
    }
}