//
//  SLReport.swift
//  Jeeran
//
//  Created by Mac on 6/13/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class SLReport: ResponseManager {
    
    
    var discussionObj : PODiscussion!
    var networkManager : NetworkManager!
    
    var response : AnyObject!
    var state : Int = 0
    var presentLayer : DiscussionReport?
    
    static func getInstance(presentLayer : AnyObject , type : Int)->SLReport{
        
        var instance:SLReport? = nil
        var onceToken:dispatch_once_t = 0
        
        dispatch_once(&onceToken){
            
            instance = SLReport(presentLayer: presentLayer , type: type)
            
        }
        return instance!
    }
    
    init(presentLayer : AnyObject , type : Int){
        if type==0{
            self.presentLayer = presentLayer as? DiscussionReport //represent the discussion
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
    
    func postReport(reasonId : Int,reportType : Int , reportId : Int,message : String){
        state = 1
        networkManager.connectTo("report/add",header: ["":""],parameters: ["report_reason_id":reasonId,"reported_type_id":reportType,"reported_id":reportId,"report_message":message],state: self.state)
    }
    
    
    func receiveResponse(resResponse:AnyObject,rState : Int){
        //        self.response = response
        switch rState {
        case 1:  //report added
            print(resResponse)
            processReplyResponse(resResponse)
        default:
            resetState()
        }
        resetState()
    }
    
    func processReplyResponse(resResponse : AnyObject){
        let json = resResponse as! [String: AnyObject]
        let response = json["result"]! as! NSDictionary
        let message : String = response.objectForKey("message") as! String
        let success : Int = response.objectForKey("success") as! Int
        
        if success == 0 {
            presentLayer?.showResponseMessage(JeeranUtil.failureTitle,msg: message)
        } else{
            presentLayer?.showResponseMessage(JeeranUtil.successTitle,msg: JeeranUtil.successMsg)
        }
    }
    
    
}
