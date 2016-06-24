//
//  FavoriteServices.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/19/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class FavoriteServices: UITableViewController {
    var servicesPlaces : ResponseFavoriteServices?
    
    var user_id : Int?
    var main_Service_id : Int?
    var id : Int?
    var serviceName : String?
    override func viewDidLoad() {
        user_id = 1
        super.viewDidLoad()
        WebserviceManager.shoFavoritewServicesPlace(ServicesURLs.servicePlaceFavoriteListURL(),header:["Authorization": ServicesURLs.token], parameters: ["user_id": self.user_id!],result: {(mainServices :ResponseFavoriteServices,code:String?)->Void
            in
            self.servicesPlaces = mainServices
            print("here",self.servicesPlaces?.serviceplaces?.count)
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
        print("============>>>>>",self.servicesPlaces?.serviceplaces!.count)
        if self.servicesPlaces == nil
        {return 0;}
        else
        {
            print("============>>>>>",self.servicesPlaces?.serviceplaces!.count)
            return (self.servicesPlaces?.serviceplaces!.count)!;
        }
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("serviceCell",forIndexPath: indexPath) as! SubServiceCell
        //         print("here",self.mainServices[0].title_en!)
        if self.servicesPlaces == nil
        {
        }
        else{
           print("h==========>>>>>",(self.servicesPlaces?.serviceplaces![indexPath.row].service_place!.logo)!)
            
                        WebserviceManager.getImage( (self.servicesPlaces?.serviceplaces![indexPath.row].service_place!.logo)! , result: { (image, code) in
                            cell.imageCell.image = image
                        })
            
         cell.cellName.text = (self.servicesPlaces?.serviceplaces![indexPath.row].service_place!.title)!
            //    cell.cellName.text = self.servicesPlaces?.serviceplaces![indexPath.row].service_place!.title!
            
            //   print("index ", self.servicesPlace[indexPath.row].service_place_id!)
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // index = indexPath.row + 1
        //    nameOfService = self.mainServicesCategory[indexPath.row].title_en!
        self.performSegueWithIdentifier("servicePlace", sender: self)
        //        let subService = SubServices()
        //        subService.main_Service_id = index!
        //        self.navigationController?.pushViewController(subService, animated: false)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier=="servicePlace"
        {
            let detailService = segue.destinationViewController as! DetailServiceViewController
            detailService.serviceName = serviceName
            detailService.main_Service_id = main_Service_id!
        }
    }
    
}
