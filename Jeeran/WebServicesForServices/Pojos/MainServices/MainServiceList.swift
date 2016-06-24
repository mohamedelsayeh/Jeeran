//
//  MainService.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/16/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class MainServiceList: Mappable { // 2 object
    var result: Result?
    var response: [ResponseService]?
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        response<-map["response"]
    }
}

