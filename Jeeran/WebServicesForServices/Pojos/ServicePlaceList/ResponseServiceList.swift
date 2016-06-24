//
//  ResponseServiceList.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ResponseServiceList: Mappable {
    // misssing rate Attrubute
    var service_place_id : Int?
    var title: String?
    var logo: String?
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        service_place_id <- map["service_place_id"]
        title <- map["title"]
          logo <- map["logo"]
          }
}