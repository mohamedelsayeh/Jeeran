//
//  ResponseFavoriteServices.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/22/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ResponseFavoriteServices: Mappable {
    // misssing rate Attrubute
        var serviceplaces : [ServicesPlaces]?
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        serviceplaces <- map["serviceplaces"]
    }
}