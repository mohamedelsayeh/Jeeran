//
//  JSONState.swift
//  Jeeran
//
//  Created by Mac on 6/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class JeeranUtil{
    
    static let successMsg : String = "Process has been successfully executed!"
    static let failureMsg : String = "Process has been failed!"
    
    static let successTitle : String = "Success..."
    static let failureTitle : String = "Failure..."
    
    
    static let DISCUSSION : Int = 0
    static let MY_DISCUSSION : Int = 1
    static let DISCUSSION_FAVORITE = 2
    
    static let REALESTATE : Int = 0
    static let MY_REALESTATE : Int = 1
    static let REALESTATE_FAVORITE : Int = 2
    
    static let NO_DATA_TAG : Int = 300
    
    static let JEERAN_FLAG : Int = 1
    
    
    static func checkResponseState(response : AnyObject)->Bool{
        let json = response as! [String: AnyObject]
        let result : NSDictionary = json["result"]! as! NSDictionary
        let errorCode = result.objectForKey("errorcode")!
        if errorCode as! NSObject == 1 {
            print("yes no data found")
            return false
        } else{
            return true
        }
    }
    
    static func isEmpty(field : UITextField)->Bool{
        let state = field.text!.isEmpty
        field.changeBorderColor(field, empty: state, msg: "")
        return state
    }
    
    
    
    
    
    
}
