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
    var service_place_image_id:Int?
    var image : String?
    var service_place_id: Int?
    var origninal: String?
    var thumb: String?
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        service_place_image_id <- map["service_place_image_id"]
        image <- map["image"]
        service_place_id <- map["service_place_id"]
        origninal <- map["origninal"]
        thumb <- map["thumb"]
    }
}