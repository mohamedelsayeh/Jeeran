//
//  FavoriteServices.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/19/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class MyServices: UITableViewController {
    var servicesPlaces : [MyServiceResponse]?
    var indexOfView : Int?
    var user_id : Int?
    var main_Service_id : Int?
    var id : Int?
    var serviceName : String?
    
    override func viewDidLoad() {
        user_id = 1
        super.viewDidLoad()
        WebserviceManager.showMyServicesPlace(ServicesURLs.servicePlaceListURL(),header:["Authorization": ServicesURLs.token], parameters: ["user_id": self.user_id!],result: {(mainServices :[MyServiceResponse],code:String?)->Void
            in
            self.servicesPlaces = mainServices
      //      print("here",self.servicesPlaces?.serviceplaces?.count)
            //            print("here",self.servicesPlaces?.serviceplaces![0].favorite_service_place_id!)
            self.tableView.hidden = false
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75;
    }
    //table part
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("============>>>>>",self.servicesPlaces?.serviceplaces!.count)
        if self.servicesPlaces == nil
        {return 0;}
        else
        {
            print("============>>>>>",self.servicesPlaces?.count)
            return (self.servicesPlaces?.count)!;
        }
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("serviceCell",forIndexPath: indexPath) as! SubServiceCell
        //         print("here",self.mainServices[0].title_en!)
        if self.servicesPlaces == nil
        {
        }
        else{
            
            WebserviceManager.getImage( (self.servicesPlaces![indexPath.row].logo)! , result: { (image, code) in
                cell.imageCell.image = image
            })
            
            cell.cellName.text = (self.servicesPlaces![indexPath.row].title)!
            //    cell.cellName.text = self.servicesPlaces?.serviceplaces![indexPath.row].service_place!.title!
            
            //   print("index ", self.servicesPlace[indexPath.row].service_place_id!)
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexOfView = (self.servicesPlaces![indexPath.row].service_place_id)!
        main_Service_id = (self.servicesPlaces![indexPath.row].service_sub_category_id)!
        
        let storyBoard = UIStoryboard(name: "MainServices", bundle: nil)
        let detailService = storyBoard.instantiateViewControllerWithIdentifier("DetailsSubView") as! DetailServiceViewController
        detailService.serviceName = serviceName
        detailService.main_Service_id = main_Service_id!
        detailService.sub_service_id = indexOfView
        self.navigationController?.pushViewController(detailService, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //        if segue.identifier=="servicePlace"
        //        {
        //
        //
        //// self.presentViewController(storyBoard.instantiateViewControllerWithIdentifier("Services"), animated: true, completion: nil)
        ////            let detailService = segue.destinationViewController as! DetailServiceViewController
        //      
        //        }
    }
    
}
