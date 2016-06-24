//
//  ServiceRate.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/20/16.
//  Copyright © 2016 Mac. All rights reserved.
//



import UIKit
import RateView

class ServiceRate: UITableViewController {
    var main_Service_id : Int?
    var id : Int?
    var serviceName : String?
    var servicesReview = [Review]()
    var rateView : RateView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 130;
    }
    //table part
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.servicesReview.count==0)
        {return 0;}
        else
        {return self.servicesReview.count;}
        
    }
    //    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        //        let cell = self.tableView.dequeueReusableCellWithIdentifier("serviceCell",forIndexPath: indexPath) as! SubServiceCell
    //        //        return cell
    //
    //
    //        let cell = self.tableView.dequeueReusableCellWithIdentifier("reviewCell",forIndexPath: indexPath) as! SubServiceCell
    //
    //        // print(self.mainServices[0].title)
    //        //         print("here",self.mainServices[0].title_en!)
    //        if(self.servicesReview.count==0)
    //        {
    //            //            cell.locationImage.image = images[indexPath.row+1]
    //            //            cell.cellName.text = names[indexPath.row]
    //            //            cell.imageCell.image = images[indexPath.row]
    //            //
    //            //            cell.cellImage.image = images[indexPath.row]
    //            //            cell.labelCell.text = names[indexPath.row]
    //            //            cell.cellNotification.titleLabel?.text = String( notification[indexPath.row])
    //        }
    //        else{
    ////            WebserviceManager.getImage( self.servicesReview[indexPath.row].logo! , result: { (image, code) in
    ////                cell.imageCell.image = image
    ////            })
    //            //   cell.locationImage.image = images[indexPath.row+1]
    //
    //            print("userNAme",self.servicesReview[indexPath.row].user!.first_name!)
    //            cell.cellName.text = self.servicesReview[indexPath.row].user!.first_name!
    //            //         id = self.servicesPlace[indexPath.row].service_place_id!
    //          //  print("index ", self.servicesPlace[indexPath.row].service_place_id!)
    //
    //            //     cell.imageCell.image = images[indexPath.row]
    //
    //        }
    //        return cell
    //    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell", forIndexPath: indexPath)
        let ratingBarView = cell.viewWithTag(3)
        let rateValue =  Float(self.servicesReview[indexPath.row].rating!)
        rateView = RateView(rating:rateValue)
        rateView?.starSize = 13
        rateView?.canRate = true
        ratingBarView!.addSubview(rateView!)
        print("servicesReview ",self.servicesReview[indexPath.row].rating!)
        let reviewImage : UIImageView! = cell.viewWithTag(1) as! UIImageView
        let reviewPerosnName : UILabel! = cell.viewWithTag(2) as! UILabel
        
        let reviewDate : UILabel! = cell.viewWithTag(4) as! UILabel
        let reviewSpec : UILabel! = cell.viewWithTag(5) as! UILabel
        let reviewDesc : UITextView! = cell.viewWithTag(6) as! UITextView
        
        print("first_name=======>",servicesReview[indexPath.row].user!.first_name!)
        reviewPerosnName.text = servicesReview[indexPath.row].user!.first_name! + " " + servicesReview[indexPath.row].user!.last_name!
        reviewDate.text = servicesReview[indexPath.row].created_at!
        reviewDesc.text = (servicesReview[indexPath.row].review)!
        
        WebserviceManager.getImage( servicesReview[indexPath.row].user!.image! , result: { (image, code) in
            reviewImage.image = image
        })
        //
        
        // reviewSpec.text = servicesReview[indexPath.row].review!
        reviewImage.layer.borderWidth = 1.0
        reviewImage.layer.cornerRadius = 37
        reviewImage.clipsToBounds = true
        reviewImage.layer.borderColor = UIColor.clearColor().CGColor
        //   reviewImage.image = UIImage(named: "img.jpg")
     return cell
    }
    //    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //
    //        // index = indexPath.row + 1
    //        //    nameOfService = self.mainServicesCategory[indexPath.row].title_en!
    //        self.performSegueWithIdentifier("servicePlace", sender: self)
    //        //        let subService = SubServices()
    //        //        subService.main_Service_id = index!
    //        //        self.navigationController?.pushViewController(subService, animated: false)
    //    }
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        if segue.identifier=="servicePlace"
    //        {
    //            let detailService = segue.destinationViewController as! DetailServiceViewController
    //            detailService.serviceName = serviceName
    //            detailService.main_Service_id = main_Service_id!
    //        }
    //    }
    //
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
