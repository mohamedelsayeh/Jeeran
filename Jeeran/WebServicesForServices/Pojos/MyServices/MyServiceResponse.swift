//
//  MyServiceResponse.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/25/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class MyServiceResponse: Mappable {
    var service_place_id: Int?
    var logo: String?
    var title: String?
    var service_sub_category_id: Int?
    required init?(_ map: Map){
    }
    
    
    func mapping(map: Map) {
        service_place_id <- map["service_place_id"]
        logo <- map["logo"]
        title <- map["title"]
        service_sub_category_id <- map["service_sub_category_id"]
    }
}