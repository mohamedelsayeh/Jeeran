
//
//  WebserviceManger.swift
//  Mobile Developer Weekend
//
//  Created by RE Pixels on 6/3/16.
//  Copyright © 2016 ITI. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import AlamofireImage

class WebserviceManager
{
    static func getImage(url : String,result: (image :UIImage,code:String?)->Void)
    {           Alamofire.request(.GET,url)
        .responseImage { response in
            switch response.result
            {
            case .Success:
             //   print(response.request)
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    result(image:image,code: "error")
                }
                                   break;
            case .Failure(let _error):
               // result(image:image,code: "error")
                print("Error")
                break;
            }
        }
        
    }
    static func getServiceImages(url : String,header:[String:String], parameters : [String : AnyObject],result: (images :[String],code:String?)->Void)
    {
        let url : URLStringConvertible = url
        Alamofire.request(.POST, url , parameters: parameters,headers:header)
            .responseJSON { response in
                switch response.result
                {
                case .Success(let _data):
                    //  print(_data.valueForKey("error")!)
                    let connectionStatus = _data["result"]!!.valueForKey("errorcode") as! Int
                    
                    switch connectionStatus
                    {
                    case 0:
                        var imageNames = [String]()
                        print("DDDDDDDDDDDDon %@",_data)
                        if let images = _data["response"] as? [[String: AnyObject]] {
                            for image in images {
                                if let imageName = image["cover_image"] as? String {
                                    imageNames.append(imageName)
                                    print("-->%@",imageName)
                                }
                            }
                            result(images: imageNames,code: "sucess")
                        }
                        else
                        {
                            result(images:[],code: "error")
                        }
                        break;
                    default:
                        result(images:[],code: "error")
                        break;
                    }
                    
                    break;
                case .Failure(let _error):
                    result(images:[],code: "error")
                    print(_error.code)
                    print(response.result)
                    break;
                }
        }
        
    }
    
    static func getMainServices(url : String,header:[String:String], parameters : [String : AnyObject],result: (mainServices :[ResponseService],code:String?)->Void)
    {
        Alamofire.request(.POST, url , parameters: parameters,headers:header).responseObject { (response: Response<MainServiceList, NSError>) in
            switch response.result
            {
            case .Success(let _data):
                let serviceResponse = response.result.value
                let status = serviceResponse?.result?.errorcode!
                
                switch status!
                {
                case 0:
                    print(serviceResponse?.response?[0].title_en!)
                    print(serviceResponse?.response)
                    result(mainServices:(serviceResponse?.response)!,code: "error")
                    break;
                    
                default:
                    result(mainServices:[],code: "error")
                    break;
                    
                }
                
                break;
            case .Failure(let _error):
                result(mainServices:[],code: "error")
                print(_error.code)
                print(response.result)
                break;
            }
            
            
        }
        
        
    }
    static func getSubServices(url : String,header:[String:String], parameters : [String : AnyObject],result: (mainServices :[ResponseSubServices],code:String?)->Void)
    {
        Alamofire.request(.POST, url , parameters: parameters,headers:header).responseObject { (response: Response<SubServicesList, NSError>) in
            switch response.result
            {
            case .Success:
                let serviceResponse = response.result.value
                let status = serviceResponse?.result?.errorcode!
                
                switch status!
                {
                case 0:
                    //                    print(serviceResponse?.response?[0].title_en!)
                    //                    print(serviceResponse?.response)
                    result(mainServices:(serviceResponse?.response)!,code: "error")
                    break;
                    
                default:
                    result(mainServices:[],code: "error")
                    break;
                }
                
                break;
            case .Failure(let _error):
                result(mainServices:[],code: "error")
                print(_error.code)
                print(response.result)
                break;
            }
        }
    }
    static func getServicesPlaceList(url : String,header:[String:String], parameters : [String : AnyObject],result: (servicesPlace :[ResponseServiceList],code:String?)->Void)
    {
        Alamofire.request(.POST, url , parameters: parameters,headers:header).responseObject { (response: Response<ServiceList, NSError>) in
            switch response.result
            {
            case .Success:
                let serviceResponse = response.result.value
                let status = serviceResponse?.result?.errorcode!
                switch status!
                {
                case 0:
                   result(servicesPlace:(serviceResponse?.response)!,code: "error")
                    break;
                    
                default:
                    result(servicesPlace:[],code: "error")
                    break;
                }
                
                break;
            case .Failure(let _error):
                result(servicesPlace:[],code: "error")
                print(_error.code)
                print(response.result)
                break;
            }
        }
    }
    
    static func showServicesPlace(url : String,header:[String:String], parameters : [String : AnyObject],result: (servicesPlace :ResponseShowServicePlace,code:String?)->Void)
    {
        Alamofire.request(.POST, url , parameters: parameters,headers:header).responseObject { (response: Response<ShowServicePlace, NSError>) in
            switch response.result
            {
            case .Success:
                let serviceResponse = response.result.value
                let status = serviceResponse?.result?.errorcode!
                switch status!
                {
                case 0:
                    result(servicesPlace:(serviceResponse?.response)!,code: "error")
                    break;
                default:
            //      result(servicesPlace:nil,code: "error")
                    break;
                }
                
                break;
            case .Failure(let _error):
       //     result(servicesPlace:nil,code: "error")
                print(_error.code)
                print(response.result)
                break;
            }
        }
    }
    
    
    static func shoFavoritewServicesPlace(url : String,header:[String:String], parameters : [String : AnyObject],result: (servicesPlace :ResponseFavoriteServices,code:String?)->Void)
    {
        Alamofire.request(.POST, url , parameters: parameters,headers:header).responseObject { (response: Response<FavoriteService, NSError>) in
            switch response.result
            {
            case .Success:
                let serviceResponse = response.result.value
                let status = serviceResponse?.result?.errorcode!
                switch status!
                {
                case 0:
                    result(servicesPlace:(serviceResponse?.response)!,code: "error")
                    break;
                default:
                    //      result(servicesPlace:nil,code: "error")
                    break;
                }
                
                break;
            case .Failure(let _error):
                //     result(servicesPlace:nil,code: "error")
                print(_error.code)
                print(response.result)
                break;
            }
        }
    }
}