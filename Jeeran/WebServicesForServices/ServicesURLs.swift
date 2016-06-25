//
//  URLs.swift
//  MDW_WebServise_Json
//
//  Created by Nrmeen Tomoum on 5/25/16.
//  Copyright © 2016 Nrmeen Tomoum. All rights reserved.
//

import Foundation

class ServicesURLs: NSObject {
  static let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIwLCJpc3MiOiJodHRwOlwvXC9qZWVyYW4uZ240bWUuY29tXC9qZWVyYW5fdjFcL3VzZXJcL2xvZ2luIiwiaWF0IjoxNDY2ODg5NzE4LCJleHAiOjE0Njc0OTQ1MTgsIm5iZiI6MTQ2Njg4OTcxOCwianRpIjoiMWMyYjc0NjJlYzI1ZTBhNjkxMGNjNzZiNjBmYzBiODkifQ.b7Jp03EQ9-0MJf5T_xOsG-I5FGZ9u6FCI8OMVqGyQNI"
    
    static  let BASEURL : String = "http://jeeran.gn4me.com/jeeran_v1"
    static func servicePlaceCategoryListURL() -> String{
        let  url = BASEURL+"/​serviceplacecategory/list"
        return  url
    }
    static func servicePlaceAddURL() -> String{
        let  url = BASEURL+"/serviceplace/add"
        return  url
    }
    static func servicePlaceEditURL() -> String{
        let  url = BASEURL+"/serviceplace/edit"
        return  url
    }
    
    static func servicePlaceDeleteURL() -> String{
        let  url = BASEURL+"/serviceplace/delete"
        return  url
    }
    static func servicePlaceListURL() -> String{
        let  url = BASEURL+"/serviceplace/list"
        return  url
    }
    static func servicePlaceImageFeatureURL() -> String{
        let  url = BASEURL+"/serviceplace/imagefeature"
        return  url
    }
    static func servicePlaceShowURL() -> String{
        let  url = BASEURL+"/serviceplace/show"
        return  url
    }
    static func servicePlaceFavoriteListURL() -> String{
        let  url = BASEURL+"/serviceplacefavorite/list"
        return  url
    }
    static func servicePlaceFavoriteAddURL() -> String{
        let  url = BASEURL+"/serviceplacefavorite/add"
        return  url
    }
    static func servicePlaceFavoriteDeleteURL() -> String{
        let  url = BASEURL+"/serviceplacefavorite/delete"
        return  url
    }
    static func servicereViewListURL() -> String{
        let  url = BASEURL+"/servicereview/list"
        return  url
    }
    
    static func serviceReviewAddURL() -> String{
        let  url = BASEURL+"/servicereview/add"
        return  url
    }
    static func serviceReviewEditURL() -> String{
        let  url = BASEURL+"/servicereview/edit"
        return  url
    }
    static func serviceReviewDeleteURL() -> String{
        let  url = BASEURL+"/servicereview/delete"
        return  url
    }
    static func servicePlace​Deleteimage() -> String{
        let  url = BASEURL+"/serviceplace​/deleteimage"
        return  url
    }
    
}
