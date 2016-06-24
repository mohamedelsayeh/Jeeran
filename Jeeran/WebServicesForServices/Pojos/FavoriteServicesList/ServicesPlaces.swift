//
//  ServicesPlaces.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/22/16.
//  Copyright © 2016 Mac. All rights reserved.
//


import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ServicesPlaces: Mappable {
    
    var favorite_service_place_id: Int?
    var service_place_id: Int?
    var user_id: Int?
    var service_place : ServicePlace?
    var user : UserN?

    var subcats: Int?
    required init?(_ map: Map){
    }
    
    
    func mapping(map: Map) {
        favorite_service_place_id <- map["favorite_service_place_id"]
        service_place_id <- map["service_place_id"]
        user_id <- map["user_id"]
        service_place <- map["service_place"]
        user <- map["user"]
    }
}