//
//  SLDiscussion.swift
//  Jeeran
//
//  Created by Mac on 6/8/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SLDiscussion :ResponseManager{
    
    var discussionObj : PODiscussion!
    var allDiscussionList : Array<PODiscussion> = []
    var topicsList : Array<POTopic> = []
    var reportReasonsList : Array<POReportReasons> = []
    var topicObj : POTopic!
    var reportReasonObj : POReportReasons!
    var discDetailsTemp : String!
    var networkManager : NetworkManager!
    
    var response : AnyObject!
    var state : Int = 0
    var presentLayer : Discussion?
    var reportPresentLayer : DiscussionReport!
    
    static func getInstance(presentLayer : AnyObject , type : Int)->SLDiscussion{
        
        var instance:SLDiscussion? = nil
        var onceToken:dispatch_once_t = 0
        
        dispatch_once(&onceToken){
            
            instance = SLDiscussion(presentLayer: presentLayer , type: type)
            
        }
        return instance!
    }
    
    init(presentLayer : AnyObject , type : Int){
        if type==0{
            self.presentLayer = presentLayer as? Discussion //represent the discussion
        } else{
            self.reportPresentLayer = presentLayer as! DiscussionReport //represent the reportdiscussion
        }
        
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
    
    
    func getDiscussionList(start:Int){
        print("get discussion list")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
 
            print("inside discusison list thread")
            self.state = 1
      
            self.networkManager.connectTo("discussion/list",header: ["":""],parameters: ["":""],state: 1)
            print("discussion list connected successfully")
            if start==0{
                self.getTopics()
                self.getRepotReasons()
            }
            
            });
    }
    
    func getDiscussionFavoriteList(){
        print("getDiscussionFavoriteList")
        state = 8
        self.networkManager.connectTo("discussionfavorite/list",header: ["":""],parameters: ["":""],state: 8)
    }
    
    func getMyDiscussionList(){
        state = 9
        self.networkManager.connectTo("discussion/list",header: ["":""],parameters: ["user_id":JeeranUtil.JEERAN_FLAG],state: 9)
    }
    
    func addFavorite(discId : Int){
        state = 2
        networkManager.connectTo("discussionfavorite/add",header: ["":""],parameters: ["disc_id":discId],state: 2)
    }
    
    func deleteFavorite(discId : Int){
        state = 5
        networkManager.connectTo("discussionfavorite/delete",header: ["":""],parameters: ["disc_id":discId],state: 5)
    }
    
    func getTopics(){
        print("Get topics\n")
        state = 3
        networkManager.connectTo("discussion/topiclist",header: ["":""],parameters: ["":""],state: self.state)
    }
    
    func addDiscussion(title : String,details : String,neighbordId : Int,topicId : Int , image : NSData!){
        state = 4
        if image != nil {
            print("image exist")
            networkManager.uploadWithAlamofire("discussion/add",header: ["":""],parameters: ["title":title,"details":details,"topic_id":String(topicId),"neighborhood_id":String(neighbordId)],imgData: image,state: self.state)
        } else{
            print("image not exist")
            networkManager.connectTo("discussion/add",header: ["":""],parameters: ["title":title,"details":details,"topic_id":topicId,"neighborhood_id":neighbordId],state: self.state)
        }
    }
    
    func getRepotReasons(){
        print("Get report reasons\n")
        state = 6
        networkManager.connectTo("report/reasonlist",header: ["":""],parameters: ["":""],state: self.state)
    }
    
    func deleteDiscussion(discId : Int){
        state = 7
        networkManager.connectTo("discussion/delete",header: ["":""],parameters: ["discussion_id":discId],state: 7)
    }
    
    
    func receiveResponse(resResponse:AnyObject,rState : Int){
//        self.response = response
        
        if !checkResponseState(resResponse) && state != 8 && state != 9 {
            print("ana hna")
            if state == 6 {
                reportPresentLayer.showResponseMessage(JeeranUtil.failureTitle, msg: JeeranUtil.failureMsg)
            } else{
                presentLayer?.showResponseMessage(JeeranUtil.failureMsg,title:JeeranUtil.failureTitle,state: self.state)
            }
        } else if !JeeranUtil.checkResponseState(resResponse) && (state == 8 || state == 9){
            presentLayer?.notifyNoDataExist()
        } else{
            print("come again")
            switch rState {
            case 1:  //render discussion list
                processDiscussionResponse(resResponse)
                presentLayer?.setDiscussionList(allDiscussionList)
            //getTopics()
            case 2: //notify favorite added
                print(resResponse)
                presentLayer?.showResponseMessage(JeeranUtil.successMsg,title: JeeranUtil.successTitle,state: 2)
            case 3: //set topics list
                print("Ready")
                processTopicsResponse(resResponse)
                presentLayer?.setTopicList(topicsList)
            case 4://discussion added
                print(resResponse)
                presentLayer?.showResponseMessage(JeeranUtil.successMsg,title: JeeranUtil.successTitle,state: 4)
                presentLayer?.reloadDiscussionData()
            case 5://notify favorite deleted
                presentLayer?.showResponseMessage(JeeranUtil.successMsg,title: JeeranUtil.successTitle,state: 5)
            case 6://get report reasons
                processReportReasonsResponse(resResponse)
                reportPresentLayer?.setReportReasonsList(reportReasonsList)
            case 7://discussion deleted
                presentLayer?.confirmDiscussionDeleted()
            case 8: //retrieve discussion favorite
                processFavoriteResponse(resResponse)
                presentLayer?.setDiscussionList(allDiscussionList)
            case 9:  //render my discussion list
                processMyDiscussionResponse(resResponse)
                presentLayer?.setDiscussionList(allDiscussionList)
            default:
                resetState()
            }
            resetState()
        }
    }
    
    func processDiscussionResponse(discussion : NSDictionary)->PODiscussion{
        discussionObj = PODiscussion()
        discussionObj.commentsNo = discussion.objectForKey("comments_no") as? Int
        discussionObj.creationDate = discussion.objectForKey("created_at") as? String
        discussionObj.updateDate = discussion.objectForKey("updated_at") as? String
        discussionObj.disDetails = discussion.objectForKey("details") as? String
        discussionObj.disTitle = discussion.objectForKey("title") as? String
        discussionObj.images = discussion.objectForKey("disc_imgs") as? NSArray
        discussionObj.userId = discussion.objectForKey("user_id") as? Int
        discussionObj.firstName = discussion.objectForKey("first_name") as? String
        discussionObj.id = discussion.objectForKey("discussion_id") as? Int
        discussionObj.isfav = discussion.objectForKey("is_fav") as? Int
        discussionObj.coverImage = discussion.objectForKey("cover_image") as? String
        discussionObj.userImage = discussion.objectForKey("user_image") as? String
        discussionObj.isOwner = discussion.objectForKey("is_owner") as? Int
        if (discussion["discussion_topic_title_ar"] != nil) {
            discussionObj.titleAr = discussion.objectForKey("discussion_topic_title_ar")! as? String
            discussionObj.titleEn = discussion.objectForKey("discussion_topic_title_en")! as? String
        }
        
        return discussionObj
    }
    
    func processFavoriteResponse(resResponse : AnyObject){
        print("...................................................................\n")
        let json = resResponse as! [String: AnyObject]
        
        
        let discussionList : NSArray = json["response"]! as! NSArray
        allDiscussionList.removeAll()
        //print(discussionList)
        for discussion in discussionList {
            
            discussionObj = processDiscussionResponse(discussion as! NSDictionary)
            
            discussionObj.favId = discussion.objectForKey("favorite_discussion_id") as? Int
            discussionObj.isfav = 1
            discussionObj.isOwner = 1
            
            self.allDiscussionList.append(discussionObj)
        }
    }
    
    
    func processMyDiscussionResponse(resResponse : AnyObject){
        //print("...................................................................\n")
        let json = resResponse as! [String: NSDictionary]
        //print(json)
        let discussionList : NSArray = json["response"]?.objectForKey("mydiscussionlist") as! NSArray
        allDiscussionList.removeAll()
        //print(discussionList)
        for discussion in discussionList {
            
            discussionObj = processDiscussionResponse(discussion as! NSDictionary)
            
            
            print(discussionObj.titleEn)
            
            self.allDiscussionList.append(discussionObj)
        }
    }
    
    func processDiscussionResponse(resResponse : AnyObject){
        //print("...................................................................\n")
        let json = resResponse as! [String: NSDictionary]
        //print(json)
        let discussionList : NSArray = json["response"]?.objectForKey("discussionlist") as! NSArray
        allDiscussionList.removeAll()
        //print(discussionList)
        for discussion in discussionList {
            
            discussionObj = processDiscussionResponse(discussion as! NSDictionary)
            
            
            print(discussionObj.titleEn)
            
            self.allDiscussionList.append(discussionObj)
        }
    }

    func processTopicsResponse(resResponse : AnyObject){
        //print("-----------------------------------------------------------------\n")
        //print(resResponse)
        let json = resResponse as! [String: AnyObject]
        
        let response = json["response"]! as! NSDictionary
        
        let topicsList:NSArray = response.objectForKey("topics") as! NSArray
        
        self.topicsList.removeAll()
        
        for topic in topicsList {
            
            topicObj = POTopic()
            
            topicObj.id = topic.objectForKey("topic_id") as? Int
            topicObj.topicEn = topic.objectForKey("topic_en") as? String
            topicObj.topicAr = topic.objectForKey("topic_ar") as? String
            
            self.topicsList.append(topicObj)
        }
        
        //print(topicsList)
        
    }
    
    func processReportReasonsResponse(resResponse : AnyObject){
        let json = resResponse as! [String: AnyObject]
        
        let response = json["response"]! as! NSDictionary
        
        let reasonsList:NSArray = response.objectForKey("reasons") as! NSArray
        
        self.reportReasonsList.removeAll()
        
        for reason in reasonsList {
            
            reportReasonObj = POReportReasons()
            
            reportReasonObj.id = reason.objectForKey("reason_id") as? Int
            reportReasonObj.reasonEn = reason.objectForKey("reason_en") as? String
            reportReasonObj.reasonAr = reason.objectForKey("reason_ar") as? String
            print(reportReasonObj.reasonEn)
            self.reportReasonsList.append(reportReasonObj)
        }
        
    }
    
    func checkResponseState(response : AnyObject)->Bool{
        print(response)
        let json = response as! [String: AnyObject]
        let result : NSDictionary = json["result"]! as! NSDictionary
        let errorCode = result.objectForKey("errorcode")!
        if errorCode as! NSObject == 1 {
            return false
        } else{
            return true
        }
    }
    
    
    
    
}
