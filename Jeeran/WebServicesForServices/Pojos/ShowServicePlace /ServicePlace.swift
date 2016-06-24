//
//  ServicePlace.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ServicePlace: Mappable {
    // misssing rate Attrubute
    var service_place_id:Int?
    var title: String?
    var description: String?
    var address: String?
    var longitude: Double?
    var latitude: Double?
    var logo: String?
    var mobile_1: String?
    var mobile_2: String?
    var mobile_3: String?
    var is_approved: Int?
    var is_hide: Int?
    var created_at: String?
    var updated_at: String?
    var service_main_category_id: Int?
    var service_sub_category_id: Int?
    var user_id : Int?
    var on_home : Int?
    var cover_image : String?
    var total_rate : Int?
    var neighbarhood_id : Int?
    var is_featured : Int?
    var opening_hours :String?
    var is_review : Int?
    var is_favorite : Int?
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        service_place_id <- map["service_place_id"]
        title <- map["title"]
        description <- map["description"]
        address <- map["address"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        logo <- map["logo"]
        mobile_1 <- map["mobile_1"]
        mobile_2 <- map["mobile_2"]
        mobile_3 <- map["mobile_3"]
        is_approved <- map["is_approved"]
        is_hide <- map["is_hide"]
        
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        service_main_category_id <- map["service_main_category_id"]
        service_sub_category_id <- map["service_sub_category_id"]
        user_id <- map["user_id"]
        on_home <- map["on_home"]
        cover_image <- map["cover_image"]
        total_rate <- map["total_rate"]
       
        neighbarhood_id <- map["neighbarhood_id"]
        is_featured <- map["is_featured"]
        opening_hours <- map["opening_hours"]
        is_review <- map["is_review"]
        is_favorite <- map["is_favorite"]
    }
}