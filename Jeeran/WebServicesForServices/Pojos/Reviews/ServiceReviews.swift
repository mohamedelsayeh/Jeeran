//
//  ServiceReviews.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/25/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ServiceReviews: Mappable {
    var service_place_review_id: Int?
    var service_place_id: Int?
    var review: String?
    var created_at: String?
    var update_at: String?
    var is_owner: Int?
    var rating: Int?
    var user : UserN?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        service_place_review_id <- map["service_place_review_id"]
        service_place_id <- map["service_place_id"]
        review <- map["review"]
        created_at <- map["created_at"]
        update_at <- map["update_at"]
        is_owner <- map["is_owner"]
        rating <- map["rating"]
        user <- map["user"]
    }
}