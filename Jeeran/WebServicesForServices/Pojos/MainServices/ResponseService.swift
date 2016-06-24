//
//  ResponseService.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/16/16.
//  Copyright © 2016 Mac. All rights reserved.
//
import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ResponseService: Mappable {
    var title_ar: String?
    var logo: String?
    var title_en: String?
    var service_main_category_id: Int?
    var subcats: Int?
    required init?(_ map: Map){
    }
    
    
    func mapping(map: Map) {
        title_ar <- map["title_ar"]
        logo <- map["logo"]
        title_en <- map["title_en"]
        service_main_category_id <- map["service_main_category_id"]
        subcats <- map["subcats"]
    }
}