//
//  ResponseServicePlaceList.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ResponseShowServicePlace: Mappable {
    // misssing rate Attrubute
    
    var   servicePlace : [ServicePlace]?
    var   review : [Review]?
    var images :[Image]?
    required init?(_ map: Map){
    }
    func mapping(map: Map) {
        servicePlace <- map["serviceplace"]
        review <- map ["review"]
        images <- map ["images"]
    }
}