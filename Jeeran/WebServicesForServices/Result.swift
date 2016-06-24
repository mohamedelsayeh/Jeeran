//
//  File.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/16/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class Result: Mappable { // 2 object
    var success: Bool?
    var message: String?
    var errorcode: Int?
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        errorcode <- map["errorcode"]
    }
}