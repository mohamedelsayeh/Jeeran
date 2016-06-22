//
//  SLRealState.swift
//  Jeeran
//
//  Created by Mac on 6/8/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class SLRealState:ResponseManager {

    
    var realStateObj : PORealState!
    var allRealStateList : Array<PORealState> = []
    var realStateList : Array<PORealState> = []
    var imageFeaturesList : Array<PORealStateImages> = []
    var topicObj : POTopic!
    var networkManager : NetworkManager!
    
    var response : AnyObject!
    var state : Int = 0
    var presentLayer : RealState?
    var presentLayerForRealEstateAdding : RealStateAdding!
    var amenitiesList : Array<POAmenities> = []
    var typesList : Array<POUnitTypes> = []
    var neighborhoodList : Array<PONeighborhood> = []
    var amentyObj : POAmenities!
    var unitType : POUnitTypes!
    var imageFeatureObj : PORealStateImages!
    var neighborhoodObj : PONeighborhood!
    
    static func getInstance(presentLayer : AnyObject , type : Int)->SLRealState{
        
        var instance:SLRealState? = nil
        var onceToken:dispatch_once_t = 0
        
        dispatch_once(&onceToken){
            if type == 0{ //for real estate
                instance = SLRealState(presentLayer: presentLayer,type: type)
            } else{ // for real estate adding
                instance = SLRealState(presentLayer: presentLayer,type: type)
            }
        }
        
        return instance!
        
    }
    
    init(presentLayer : AnyObject , type : Int){
        if type==0 {
            self.presentLayer = presentLayer as? RealState
        } else{
            self.presentLayerForRealEstateAdding = presentLayer as! RealStateAdding
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
    
    
    func getRealStateList(){
        state = 1
        networkManager.connectTo("realstate/list",header: ["":""],parameters: ["":""],state: self.state)
    }
    
    func getMyRealEstateList(){
        state = 9
        networkManager.connectTo("realstate/list",header: ["":""],parameters: ["user":JeeranUtil.JEERAN_FLAG],state: self.state)
    }
    
    func getFavoriteRealEstateList(){
        state = 8
        networkManager.connectTo("realstatefavorite/list",header: ["":""],parameters: ["":""],state: self.state)
    }
    
    
    func deleteRealState(id : Int){
        state = 2
        networkManager.connectTo("realstate/delete",header: ["":""],parameters: ["realstate_id":id],state: self.state)
    }
    
    func deleteFavoriteRealState(id : Int){
        state = 7
        networkManager.connectTo("realstatefavorite/delete",header: ["":""],parameters: ["favorite_id":id],state: self.state)
    }
    
    func addRealState(realState : PORealState , image : NSData!){
        state = 3
        let parameters = [
            "type":realState.type!.toString(),
            "title":realState.rsTitle!,
            "description":realState.description!,
            "location":realState.rsLocation!,
            "number_of_rooms":realState.numOfRooms!.toString()
            ,"number_of_bathrooms":realState.numOfBathRooms!.toString()
            ,"area":realState.area!
            ,"price":realState.rsPrice!.toString()
            ,"latitude":realState.latitude!.toString()
            ,"longitude":realState.longitude!.toString()
            ,"language":(realState.language?.toString())!,
             "owner_mobile":realState.ownerMobile!,
             "owner_name":realState.ownerName!,
             "owner_email":realState.ownerEmail!,
             "unit_type_id":realState.unitTypeId!.toString(),
             "neighbarhood_id":realState.neighbarhoodId!.toString(),
             "amenities_id":realState.amenitiesId!.toString()
        ]
        
        if image != nil {
            print("exist image")
            networkManager.uploadWithAlamofire("realstate/add", header: ["":""], parameters:parameters,imgData: image, state: self.state)
        } else{
            print("not exist image")
            networkManager.connectTo("realstate/add", header: ["":""], parameters: parameters
                , state: self.state)
        }
    }
    
    func loadDependencies(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            self.getAmenities()
            self.getTypesList()
            self.getNeighborhoodList()
        });
    }
    
    
    func getAmenities(){
        state = 4
        self.networkManager.connectTo("realstate/amenitelist",header: ["":""],parameters: ["":""],state: 4)
    }
    
    func getTypesList(){
        state = 5
        self.networkManager.connectTo("realstate/unittypelist",header: ["":""],parameters: ["":""],state: 5)
    }
    
    
    func getNeighborhoodList(){
        state = 6
        self.networkManager.connectTo("neighborhood/list",header: ["":""],parameters: ["":""],state: 6)
    }
    
    func getRealEstateImageFeatures(){
        state = 10
        self.networkManager.connectTo("realstate/imagefeature",header: ["":""],parameters: ["":""],state: 10)
    }
    
    
    func receiveResponse(response:AnyObject,rState:Int){
        self.response = response
//         print(response)
        if !JeeranUtil.checkResponseState(response) && state != 8 && state != 9 {
            if state==4 || state==5 || state==6 {
                presentLayerForRealEstateAdding.showResponseMessage(JeeranUtil.failureMsg, title: JeeranUtil.failureTitle)
            }
        } else if !JeeranUtil.checkResponseState(response) && (state == 8 || state == 9) {
           
            presentLayer?.notifyNoDataExist()
        } else{
            print("data exist")
            switch rState {
            case 1,9:  //render data
                processResponse()
                presentLayer?.setRealStateList(allRealStateList)
            case 2: //delete real estate
                print(response)
            //presentLayer?.commitSuccess()
            case 3:
                presentLayerForRealEstateAdding.showResponseMessage(JeeranUtil.successMsg, title: JeeranUtil.successTitle)
                print(response)
            case 4: //get Amentities
                processAmenitiesResponse(response)
                presentLayerForRealEstateAdding.setAmenities(amenitiesList)
            case 5: //get types list
                processUnitTypesResponse(response)
                presentLayerForRealEstateAdding.setTypesList(typesList)
            case 6: //get neighborhood list
                processNeighborhoodResponse(response)
                presentLayerForRealEstateAdding.setNeighborhoodList(neighborhoodList)
            case 7: //delete real estate favorite
                print(response)
            case 8:
                processFavoriteRealEstateResponse()
                presentLayer?.setRealStateList(allRealStateList)
            case 10:
//                print(response)
                processImageFeatureResponse()
                presentLayer?.setImageFeaturesList(imageFeaturesList)
            default:
                resetState()
            }
        }
        
        
        resetState()
    }
    
    func processRealEstateResponse(realState:NSDictionary)->PORealState{
            realStateObj = PORealState()
            realStateObj.id = realState.objectForKey("real_estate_ad_id") as? Int
            realStateObj.rsTitle = realState.objectForKey("title") as? String
            realStateObj.description = realState.objectForKey("description") as? String
            realStateObj.rsLocation = realState.objectForKey("location") as? String
            realStateObj.type = realState.objectForKey("type") as? Int
            realStateObj.numOfRooms = realState.objectForKey("number_of_rooms") as? Int
            realStateObj.numOfBathRooms = realState.objectForKey("number_of_bathrooms") as? Int
            realStateObj.rsPrice = realState.objectForKey("price") as? Int
            realStateObj.area = realState.objectForKey("area") as? String
            realStateObj.longitude = realState.objectForKey("longitude") as? Double
            realStateObj.latitude = realState.objectForKey("latitude") as? Double
            realStateObj.language = realState.objectForKey("language") as? Int
            realStateObj.createionDate = realState.objectForKey("created_at") as? String
            realStateObj.updateDate = realState.objectForKey("updated_at") as? String
            realStateObj.userId = realState.objectForKey("user_id") as? Int
            realStateObj.ownerName = realState.objectForKey("owner_name") as? String
            realStateObj.ownerMobile = realState.objectForKey("owner_mobile") as? String
            realStateObj.ownerEmail = realState.objectForKey("owner_email") as? String
            realStateObj.onHome = realState.objectForKey("on_home") as? Int
            realStateObj.coverImage = realState.objectForKey("cover_image") as? String
            realStateObj.unitTypeId = realState.objectForKey("unit_type_id") as? Int
            realStateObj.neighbarhoodId = realState.objectForKey("neighbarhood_id") as? Int
            realStateObj.isFeatured = realState.objectForKey("is_featured") as? Int
            realStateObj.amenitiesId = realState.objectForKey("amenities_id") as? Int
            realStateObj.isOwner = realState.objectForKey("is_owner") as? Int
            realStateObj.realEstateAdImage = realState.objectForKey("real_estate_ad_image") as? Array<NSDictionary>
        return realStateObj
    }
    
    func processResponse(){
        let json = self.response as! [String: AnyObject]
        let realSatateList : NSArray = json["response"]! as! NSArray
        allRealStateList.removeAll()
        //print(discussionList)
        for realState in realSatateList {
            realStateObj = processRealEstateResponse(realState as! NSDictionary)
            self.allRealStateList.append(realStateObj)
        }
    }
    
    func processImageFeatureResponse(){
        let json = self.response as! [String: AnyObject]
        let imgFeatureList : NSArray = json["response"]! as! NSArray
        imageFeaturesList.removeAll()
        for imgFeature in imgFeatureList {
            imageFeatureObj = PORealStateImages()
            imageFeatureObj.coverImage = imgFeature.objectForKey("cover_image") as! String
            imageFeatureObj.title = imgFeature.objectForKey("title") as! String
            self.imageFeaturesList.append(imageFeatureObj)
        }
    }
    
    func processFavoriteRealEstateResponse(){
        let json = self.response as! [String: AnyObject]
        let realSatateList : NSArray = json["response"]!["realstate"] as! NSArray
        allRealStateList.removeAll()
        for favRealState in realSatateList {
            let realState : NSDictionary = favRealState.objectForKey("real_estate_ad") as! NSDictionary
            realStateObj = processRealEstateResponse(realState)
            realStateObj.isOwner = 1
            realStateObj.favId = favRealState.objectForKey("favorite_real_estate_ad_id") as! Int
            realStateObj.favUserId = favRealState.objectForKey("user_id") as! Int
            realStateObj.favRealStateId = favRealState.objectForKey("real_estate_ad_id") as! Int
            self.allRealStateList.append(realStateObj)
        }
    }
    
    
    
    func processAmenitiesResponse(resResponse : AnyObject){
        let json = resResponse as! [String: AnyObject]
        let list : NSArray = json["response"]! as! NSArray
        self.amenitiesList.removeAll()
        for amenty in list {
            amentyObj = POAmenities()
            amentyObj.id = amenty.objectForKey("amenities_id") as? Int
            amentyObj.titleEn = amenty.objectForKey("title_en") as? String
            amentyObj.titleAr = amenty.objectForKey("title_ar") as? String
            self.amenitiesList.append(amentyObj)
        }
    }
    
    func processUnitTypesResponse(resResponse : AnyObject){
        let json = resResponse as! [String: AnyObject]
        let list : NSArray = json["response"]! as! NSArray
        self.typesList.removeAll()
        for amenty in list {
            unitType = POUnitTypes()
            unitType.id = amenty.objectForKey("unit_type_id") as? Int
            unitType.titleEn = amenty.objectForKey("title_en") as? String
            unitType.titleAr = amenty.objectForKey("title_ar") as? String
            self.typesList.append(unitType)
        }
    }
    
    func processNeighborhoodResponse(resResponse : AnyObject){
        let json = resResponse as! [String: AnyObject]
        let response = json["response"]! as! NSDictionary
        let list:NSArray = response.objectForKey("neighborhoods") as! NSArray
        self.neighborhoodList.removeAll()
        for neighborhood in list {
            neighborhoodObj = PONeighborhood()
            neighborhoodObj.id = neighborhood.objectForKey("id") as? Int
            neighborhoodObj.titleEn = neighborhood.objectForKey("title_en") as? String
            neighborhoodObj.titleAr = neighborhood.objectForKey("title_ar") as? String
            self.neighborhoodList.append(neighborhoodObj)
        }
    }
    
    

    
}
