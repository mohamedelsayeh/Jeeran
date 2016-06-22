//
//  NetworkManager.swift
//  Jeeran
//
//  Created by Mohammed on 6/5/16.
//  Copyright © 2016 Information Technology Institute. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
import ObjectMapper
class NetworkManager {
    let BASEURL : String = "http://jeeran.gn4me.com/jeeran_v1/"
    typealias responseImageHandler = (NSData) -> Void

    var loginView : LoginViewDelegate!
    var registerationView : RegisterViewDelegate!
    var facebookLoginDelegate : FacebookLoginDelegate!
    var profileView : ProfileViewDelegate!
    let deviceToken = (UIApplication.sharedApplication().delegate as! AppDelegate).deviceToken
    var token : String!

    var caller : ResponseManager!

    
    func connectTo(url : String,header:[String:String], parameters : [String : AnyObject] , state: Int) {
        let url : URLStringConvertible = BASEURL + url
        
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        Alamofire.request(.POST, url , parameters: parameters,headers:["Authorization":"Bearer " + token]).responseJSON { (response) in
            dispatch_async(dispatch_get_main_queue(), {
                if response.result.value != nil{
                    self.getRemoteWebServiceResult(response.result.value!,state: state)
                }
            })
        }
    }
    
    
    func loginWith(username : String, password : String) {
        let url = BASEURL + "user/login"
        let parameters : [String : AnyObject] = [
            "email":username,
            "password":password,
            "device_token":deviceToken,
            "device_type":1,
            ]
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { (response) in
            let jsonResult = JSON(data: response.data!)
            print(jsonResult)
            if jsonResult == nil {
                self.loginView.receiveLoginResult(false, result: "Please check your internet connection", token: "")
            }
            else {
                switch jsonResult["result"]["errorcode"] {
                case 0: //Success
                    if jsonResult["token"] != "" {
                        self.loginView.receiveLoginResult(true, result: "", token: jsonResult["token"].stringValue)
                    } else {
                        self.loginView.receiveLoginResult(false, result: "Your account is not active yet!", token: "")
                    }
                    break
                case 1: //Missing Inputs
                    self.loginView.receiveLoginResult(false, result: "This email address is not existed", token: "")
                    break
                case 2: //No result found
                    self.loginView.receiveLoginResult(false, result: "Invalid username or password", token: "")
                    break
                default: //Unknown error
                    self.loginView.receiveLoginResult(false, result: "Unknown Error!", token: "")
                }
            }
        }
    }
    
    func forgotPassword(username : String) {
        let url = BASEURL + "user/forgetpassword"
        let parameters : [String : AnyObject] = [
            "email":username,
            ]
        Alamofire.request(.GET, url, parameters: parameters).responseJSON { (response) in
            let jsonResult = JSON(data: response.data!)
            print(jsonResult)
            if jsonResult == nil {
                self.loginView.receiveForgotPasswordResult("Please check your internet connection")
            }
            else {
                switch jsonResult["result"]["errorcode"] {
                case 0: //Success
                    self.loginView.receiveForgotPasswordResult(jsonResult["result"]["message"].stringValue)
                    break
                default: //Unknown error
                    if jsonResult["result"]["message"]["email"] == nil {
                        self.loginView.receiveForgotPasswordResult(jsonResult["result"]["message"].stringValue)
                    } else {
                        self.loginView.receiveForgotPasswordResult(jsonResult["result"]["message"]["email"].arrayObject?.first as! String)
                    }
                }
            }
        }
    }
    
    
    func loginWithFacebook(username : String, emailAddress : String, facebookId : String, imageUrl : String) {
        let url = BASEURL + "user/loginfb"
//        let parameters : [String : AnyObject] = [
//            "name":username,
//            "email":emailAddress,
//            "facebook_id":facebookId,
//            "device_token":deviceToken,
//            "device_type":"1",
//            ]
        let parameters = [
            "name":username,
            "email":emailAddress,
            "facebook_id":facebookId,
            "device_token":deviceToken,
            "device_type": "1",
            "image": imageUrl
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, headers: nil).responseJSON {  (response) in
            var jsonResult = JSON(data: response.data!)
            //                    print(jsonResult["result"]["message"])
            print(response)
            if jsonResult == nil {
                self.facebookLoginDelegate.receiveFBLoginResult(false, result: "Please check your internet connection", token: "")
            }
            else {
                switch jsonResult["result"]["errorcode"] {
                case 0: //Success
                    self.facebookLoginDelegate.receiveFBLoginResult(true, result: "", token: jsonResult["token"].stringValue)
                    break
                default: //Unknown error
                    self.facebookLoginDelegate.receiveFBLoginResult(false, result: "Registration ERROR!", token: "")
                }
            }
        }
    }
    
    func registerUser(name : String, email : String, password : String, image : UIImage) {
        let url = BASEURL + "user/register"
        
        let parameters = [
            "full_name":name,
            "email":email,
            "password":password,
            "password_confirmation":password,
            "device_token":deviceToken,
            "device_type": "1"
        ]
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        //        let manager = AFHTTPSessionManager()
        //        manager.POST(url, parameters: nil, constructingBodyWithBlock: { (formData) in
        //            formData.appendPartWithFileData(imageData!, name: "image", fileName: "image.png", mimeType: "image/png")
        //            for (key, value) in parameters {
        //                formData.appendPartWithFormData(value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
        //            }
        //            }, success: { (task, response) in
        //                print(response)
        //            }) { (task, error) in
        //                print(error)
        //        }
        
        
        Alamofire.upload(.POST, url, multipartFormData: { (multipartFormData) in
            multipartFormData.appendBodyPart(data: imageData!, name: "image", fileName: "imageay.jpg", mimeType: "image/jpg")
            
            for (key, value) in parameters {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
        }) { (encodingResult) in
            switch encodingResult{
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    var jsonResult = JSON(data: response.data!)
                    print(jsonResult["result"]["message"])
                    if jsonResult == nil {
                        self.registerationView.receiveRegisterationResult(false, result: "Please check your internet connection")
                    }
                    else {
                        print(response)
                        switch jsonResult["result"]["errorcode"] {
                        case 0: //Success
                            self.registerationView.receiveRegisterationResult(true, result: "SUCCESS, Please wait for validation email")
                            break
                        default: //Unknown error
                            self.registerationView.receiveRegisterationResult(false, result: "Registration ERROR!")
                        }
                    }
                })
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getUserProfile() {
        let url = BASEURL + "user/myprofile"
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        Alamofire.request(.GET, url, parameters: ["device_token":deviceToken], headers: ["Authorization":"Bearer " + token]).responseJSON { (response) in
            print(response)
            switch response.result {
            case .Success(let json):
                print(json.valueForKey("response"))
                if json.valueForKey("response") != nil {
                    let user : User = Mapper<User>().map(json.valueForKey("response"))!
                    (UIApplication.sharedApplication().delegate as! AppDelegate).user = user
                    self.profileView.receiveUserData(user)
                }
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    func logout() {
        let url = BASEURL + "user/logout"
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        Alamofire.request(.GET, url, parameters: ["device_token":deviceToken], headers: ["Authorization":"Bearer " + token]).responseJSON { (response) in
            print(response)
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    
    ////////////////////////////Discussion & RealEstate Ramadan ///////////////////////////
    
    func uploadWithAlamofire(url : String,header:[String:String], parameters : [String : String] ,imgData : NSData, state: Int) {
        
        //        print(imgData)
        
        let url : URLStringConvertible = BASEURL + url
        
        // Begin upload
        Alamofire.upload(.POST, url,
                         // define your headers here
            headers:["Authorization":"Bearer "+token],
            multipartFormData: { multipartFormData in
                
                // import image to request
                multipartFormData.appendBodyPart(data: imgData, name: "images[]", fileName: "myImage.png", mimeType: "image/png")
                
                // import parameters
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                print(multipartFormData.contentLength)
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print(".............")
                        print(response)
                        self.getRemoteWebServiceResult(response.result.value!,state: state)
                                                debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    
    func getRemoteWebServiceResult(response : AnyObject , state : Int){
        caller?.receiveResponse(response,rState: state)
    }
    
    
    static func loadImage(url : String , completionHandler :responseImageHandler){
        Alamofire.request(.GET, url).response { (request, response, data, error) in
            completionHandler(data!)
        }
        
        
        //        Alamofire.request(.GET, "https://robohash.org/123.png").response { (request, response, data, error) in
        //            self.myImageView.image = UIImage(data: data, scale:1)
        //        }
    }
    
    
    
}