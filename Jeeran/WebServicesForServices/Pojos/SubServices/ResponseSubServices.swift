//
//  ResponseSubServices.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/17/16.
//  Copyright © 2016 Mac. All rights reserved.
//
import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ResponseSubServices: Mappable {
    // misssing rate Attrubute 
    var service_main_category_Id : Int?
    var title_ar: String?
    var title_en: String?
    var main_category: Int?
    var logo: String?
    var is_main: Int?
    var services: Int?
     required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        service_main_category_Id <- map["service_main_category_Id"]
        title_ar <- map["title_ar"]
        title_en <- map["title_en"]
        main_category <- map["main_category"]
        logo <- map["logo"]
        is_main <- map["is_main"]
        services <- map["services"]
    }
}