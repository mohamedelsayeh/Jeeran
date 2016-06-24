//
//  URLs.swift
//  MDW_WebServise_Json
//
//  Created by Nrmeen Tomoum on 5/25/16.
//  Copyright © 2016 Nrmeen Tomoum. All rights reserved.
//

import Foundation

class ServicesURLs: NSObject {
  static let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIwLCJpc3MiOiJodHRwOlwvXC9qZWVyYW4uZ240bWUuY29tXC9qZWVyYW5fdjFcL3VzZXJcL2xvZ2luIiwiaWF0IjoxNDY2NTMyOTM0LCJleHAiOjE0NjcxMzc3MzQsIm5iZiI6MTQ2NjUzMjkzNCwianRpIjoiYWZkZGFiZWU1MTM1MWNlZTg2YjI1ZmNkN2YyYWNkOGQifQ.K9g8UUx5Ni1Vf-Z3e5h9ArIZxATdVE3Gt9Ga-qYSfYg"
    
    
    
//    static let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIwLCJpc3MiOiJodHRwOlwvXC9qZWVyYW4uZ240bWUuY29tXC9qZWVyYW5fdjFcL3VzZXJcL2xvZ2luIiwiaWF0IjoxNDY2NTMyODc5LCJleHAiOjE0NjcxMzc2NzksIm5iZiI6MTQ2NjUzMjg3OSwianRpIjoiZThiNDE5OWU5NmNhM2IyYjY4MmMwYzNiNGQwY2FkZmIifQ.g99Lzp0MsTbZFBZVU2-n2mPnf54eV_36DzaxmswiQV"

    
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
