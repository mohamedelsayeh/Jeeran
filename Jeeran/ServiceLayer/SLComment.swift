//
//  SLComment.swift
//  Jeeran
//
//  Created by Mac on 6/8/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SLComment:ResponseManager {

    var commentObj : POComment!
    var allCommentList : Array<POComment> = []
    var discDetailsTemp : String!
    var networkManager : NetworkManager!
    
    var response : AnyObject!
    var state : Int = 0
    var presentLayer : Comments?
    
    
    static func getInstance(presentLayer : Comments)->SLComment{
        
        var instance:SLComment? = nil
        var onceToken:dispatch_once_t = 0
        
        dispatch_once(&onceToken){
            
            instance = SLComment(presentLayer: presentLayer)
            
        }
        
        return instance!
        
    }
    
    init(presentLayer : Comments){
        self.presentLayer = presentLayer
        connectWS()
    }
    
    
    func connectWS(){
        
        networkManager = NetworkManager()
        networkManager.caller = self
        
    }
    
    
    func setState(state : Int){
        self.state = state
    }
    
    func resetState(){
        state = 0
    }
    
    func getCommentsList(discId :Int){
        state = 1
        networkManager.connectTo("discussioncomments/list",header: ["":""],parameters: ["disc_id":discId],state: self.state)
    }
    
    func postComment(discId : Int , comment : String){
        state = 2
        networkManager.connectTo("discussioncomments/add",header: ["":""],parameters: ["disc_id":discId,"comment":comment],state: self.state)
    }
    
    func deleteComment(id : Int){
        state = 3
        networkManager.connectTo("discussioncomments/delete",header: ["":""],parameters: ["discussion_comment_id":id],state: self.state)
    }
    
    func receiveResponse(response:AnyObject,rState:Int){
        self.response = response
        switch rState {
        case 1:  //render data
            if checkResponseState(response){
                presentLayer?.toggleTable(false)
                processResponse()
                presentLayer?.setCommentList(allCommentList)
            } else{
                presentLayer?.toggleTable(true)
            }
            
        case 2: //post comment
            presentLayer?.commitSuccess(2)
            presentLayer?.loadComments()
            print(response)
        case 3: //delete comment
            print("respone")
            presentLayer?.commitSuccess(3)
        default:
            resetState()
        }
        resetState()
    }
    
    func processResponse(){
        
        let json = self.response as! [String: AnyObject]
        
        print(json)
        
        let commentsList : NSArray = json["response"]! as! NSArray
        allCommentList.removeAll()
        for comment in commentsList {
            
            commentObj = POComment()
            
            commentObj.id = comment.objectForKey("discussion_comment_id") as? Int
            commentObj.comment = comment.objectForKey("comment") as? String
            commentObj.discId = comment.objectForKey("discussion_id") as? Int
            commentObj.userId = comment.objectForKey("user_id") as? Int
            commentObj.isHide = comment.objectForKey("is_hide") as? Int
            commentObj.creationDate = comment.objectForKey("created_at") as? String
            commentObj.updateDate = comment.objectForKey("updated_at") as? String
            commentObj.isOwner = comment.objectForKey("is_owner") as? Int
            
            let userJson : NSDictionary = (comment.objectForKey("user") as? NSDictionary)!
            
            let userObj : POUser = POUser()
            userObj.id = userJson.objectForKey("user_id") as? Int
            userObj.isActive = userJson.objectForKey("is_active") as? Int
            userObj.firstName = userJson.objectForKey("first_name") as? String
            userObj.lastName = userJson.objectForKey("last_name") as? String
            userObj.image = userJson.objectForKey("image") as? String
            userObj.email = userJson.objectForKey("email") as? String
            userObj.dateOfBirth = userJson.objectForKey("date_of_birth") as? String
            userObj.mobile = userJson.objectForKey("mobile_number") as? String
            
            commentObj.user = userObj
            
            self.allCommentList.append(commentObj)
        }
    }
    
    func addFavorite(discId : Int){
        
        state = 2
        
        networkManager.connectTo("discussionfavorite/add",header: ["":""],parameters: ["disc_id":discId],state: self.state)
        
    }
    
    func checkResponseState(response : AnyObject)->Bool{
        let json = self.response as! [String: AnyObject]
        let result : NSDictionary = json["result"]! as! NSDictionary
        return result.objectForKey("success") as! Bool
    }
    
}
