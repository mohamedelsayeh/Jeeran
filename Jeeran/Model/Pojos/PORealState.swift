//
//  PORealState.swift
//  Jeeran
//
//  Created by Mac on 6/6/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class PORealState {
    var id : Int?
    var rsTitle : String!
    var description : String!
    var rsLocation : String!
    var type : Int!
    var numOfRooms : Int!
    var numOfBathRooms : Int!
    var rsPrice : Int!
    var area : String!
    var longitude : Double!
    var latitude : Double!
    var language : Int?
    var isHide : Int?
    var createionDate : String?
    var updateDate : String?
    var userId : Int?
    var ownerName : String?
    var ownerMobile : String?
    var ownerEmail : String?
    var onHome : Int?
    var coverImage : String?
    var unitTypeId : Int!
    var neighbarhoodId : Int!
    var isFeatured : Int?
    var amenitiesId : Int!
    var amenites : String?
    var realEstateAdImage : Array<NSDictionary>?
    var isOwner : Int!
    
    //......Favorites
    var favId : Int!
    var favUserId : Int!
    var favRealStateId : Int!
    
}
