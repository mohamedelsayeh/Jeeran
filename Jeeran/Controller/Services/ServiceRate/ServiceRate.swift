//
//  ServiceRate.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/20/16.
//  Copyright © 2016 Mac. All rights reserved.
//
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
    var service_place_id : Int?
   // var servicesReview = [Review]()
      var rateView : RateView?

    var serviceReviews = [ServiceReviews]()
    var isOwner : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
    WebserviceManager.rateServicePlace(ServicesURLs.servicereViewListURL()+"?service_place_id="+String(service_place_id!), header: ["Authorization": ServicesURLs.token], parameters: [:]) { (service_reviews, code) in
             self.serviceReviews = service_reviews
    print("vvvvvvvvvv",self.serviceReviews.count,self.serviceReviews[0].user?.first_name)
    self.tableView.hidden = false
    self.tableView.reloadData()
        }
        //  WebserviceManager.rateServicePlace(ServicesURLs., header: <#T##[String : String]#>, parameters: <#T##[String : Int]#>, result: <#T##(result: Result, code: String?) -> Void#>)
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
       // print("vvvvvvvvvv2222222222",self.serviceReviews.count,self.serviceReviews[0].user?.first_name)

        if(self.serviceReviews.count==0)
        {return 0;}
        else
        {return self.serviceReviews.count;}
        
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
    //print("userNAme",self.servicesReview[indexPath.row].user!.first_name!)
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
        if self.serviceReviews.count == 0
        {}
        else{
        print("vvvvvvvvvv333333",self.serviceReviews.count,self.serviceReviews[0].user?.first_name)

      //  print("first_name=======>",serviceReviews[indexPath.row].user!.first_name!)

        
       if let tedt = self.serviceReviews[indexPath.row].rating
  {
        let ratingBarView = cell.viewWithTag(3)
        let rateValue =  Float(self.serviceReviews[indexPath.row].rating!)
        rateView = RateView(rating:rateValue)
        rateView?.starSize = 13
        rateView?.canRate = true
        ratingBarView!.addSubview(rateView!)
            }
            else
       {
        
        let ratingBarView = cell.viewWithTag(3)
        let rateValue =  Float(0)
        rateView = RateView(rating:rateValue)
        rateView?.starSize = 13
        rateView?.canRate = true
        ratingBarView!.addSubview(rateView!)
            }
        let optionButton : UIButton! = cell.viewWithTag(9) as! UIButton
        if self.serviceReviews[indexPath.row].is_owner! == 0
        {
         optionButton.hidden = true
        }
      //  print("servicesReview ",self.serviceReviews[indexPath.row].rating!)
        //        let options : UIButton! = cell.viewWithTag(9) as! UIButton
        //      //  options.addac
        //        //showMoreOptions
        //        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ServiceRate.showMoreOptions(_:)))
        
        //    options.addGestureRecognizer(gestureRecognizer)
        
        let reviewImage : UIImageView! = cell.viewWithTag(1) as! UIImageView
        
        
        let reviewPerosnName : UILabel! = cell.viewWithTag(2) as! UILabel
        
        let reviewDate : UILabel! = cell.viewWithTag(4) as! UILabel
        let reviewSpec : UILabel! = cell.viewWithTag(5) as! UILabel
        let reviewDesc : UITextView! = cell.viewWithTag(6) as! UITextView
        
        
        print("first_name=======>",serviceReviews[indexPath.row].user!.first_name!)
        reviewPerosnName.text = serviceReviews[indexPath.row].user!.first_name! + " " + serviceReviews[indexPath.row].user!.last_name!
        reviewDate.text = serviceReviews[indexPath.row].created_at!
        reviewDesc.text = (serviceReviews[indexPath.row].review)!
        //   isOwner = servicesReview[indexPath.row].
        
        WebserviceManager.getImage( serviceReviews[indexPath.row].user!.image! , result: { (image, code) in
            reviewImage.image = image
        })
        //
        
        // reviewSpec.text = servicesReview[indexPath.row].review!
        reviewImage.layer.borderWidth = 1.0
        reviewImage.layer.cornerRadius = 37
        reviewImage.clipsToBounds = true
        reviewImage.layer.borderColor = UIColor.clearColor().CGColor
            
        }
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
    
    
    
    @IBAction func actinForOptions(sender: AnyObject) {
        //        setCurrentDiscussion(sender)
        //        print(currentDiscussion.id)
        let moreOprionsActionSheet : UIAlertController = UIAlertController(title: "Please select option", message: "", preferredStyle: .ActionSheet)
        //
        //        if currentDiscussion.isOwner == 1 {
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (topicActionSheetClosure) in
            //   self.toggleNetworkAnimator(1)
            //   self.serviceLayer.deleteDiscussion(self.currentDiscussion.id!)
        }))
        //        }
        //
        //
        //
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Edit", style: .Default, handler: { (topicActionSheetClosure) in
            
            //     self.setCurrentDiscussion(sender)
            
            //let reportReasonsView : DiscussionReport = self.storyboard!.instantiateViewControllerWithIdentifier("DiscussionReport") as! DiscussionReport
            // reportReasonsView.reportTypeId = 4
            //    reportReasonsView.reportId = self.currentDiscussion.id
            //  self.navigationController?.pushViewController(reportReasonsView, animated: true)
        }))
        //
        
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        self.presentViewController(moreOprionsActionSheet, animated: true, completion: nil)
    }
    //func showMoreOptions(gestureRecognizer: UIGestureRecognizer) {
    //
    //}
    
    
    @IBAction func test(sender: AnyObject) {
        //        setCurrentDiscussion(sender)
        //        print(currentDiscussion.id)
        let moreOprionsActionSheet : UIAlertController = UIAlertController(title: "Please select option", message: "", preferredStyle: .ActionSheet)
        //
        //        if currentDiscussion.isOwner == 1 {
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (topicActionSheetClosure) in
            //   self.toggleNetworkAnimator(1)
            //   self.serviceLayer.deleteDiscussion(self.currentDiscussion.id!)
        }))
        //        }
        //
        //
        //
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Edit", style: .Default, handler: { (topicActionSheetClosure) in
            
            //     self.setCurrentDiscussion(sender)
            
            //let reportReasonsView : DiscussionReport = self.storyboard!.instantiateViewControllerWithIdentifier("DiscussionReport") as! DiscussionReport
            // reportReasonsView.reportTypeId = 4
            //    reportReasonsView.reportId = self.currentDiscussion.id
            //  self.navigationController?.pushViewController(reportReasonsView, animated: true)
        }))
        //
        
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        
        self.navigationController?.pushViewController(moreOprionsActionSheet, animated: true)
        //self.presentViewController(moreOprionsActionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


