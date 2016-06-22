//
//  RealState.swift
//  Jeeran
//
//  Created by Mac on 6/21/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import Auk

class RealState: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var rSTitle : UILabel!
    var rSLocation : UILabel!
    var rSDate : UILabel!
    var rSPrice : UILabel!
    var rSImage : UIImageView!
    var allRealStateList : Array<PORealState> = []
    var imageFeaturesList : Array<PORealStateImages> = []
    var serviceLayer : SLRealState!
    var currentRealState : PORealState!
    var userId : Int = 2
    var type : Int = 0
    var currentIndex : Int!
    
    @IBOutlet weak var realEstateTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var realStateTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.removeBackBarButtonItem()
        serviceLayer = SLRealState.getInstance(self,type: 0)
        toggleNetworkLoading(true)
        
        if type == JeeranUtil.MY_REALESTATE || type == JeeranUtil.REALESTATE_FAVORITE {
            realEstateTopConstraint.constant = -(self.view.frame.size.height - realStateTableView.frame.size.height)+50.0
        } else{
            serviceLayer.getRealEstateImageFeatures()
        }
        getList()
    }
    
    func getList(){
        if type == JeeranUtil.REALESTATE {
            serviceLayer.getRealStateList()
        } else if type == JeeranUtil.MY_REALESTATE{
            serviceLayer.getMyRealEstateList()
        } else if type == JeeranUtil.REALESTATE_FAVORITE{
            serviceLayer.getFavoriteRealEstateList()
        }
    }
    
    func decideWhatToDoAfterDelete(){
        if type == JeeranUtil.REALESTATE_FAVORITE || type == JeeranUtil.MY_REALESTATE{
            if allRealStateList.count==0 {
                notifyNoDataExist()
            } else{
                realStateTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Welcome again")
        toggleNetworkLoading(true)
        getList()
    }
    
    func toggleNetworkLoading(state : Bool){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = state
    }
    
    
    func setRealStateList(allRealStateList : Array<PORealState>){
        toggleNetworkLoading(false)
        self.allRealStateList = allRealStateList
        print("length = \(self.allRealStateList.count)")
        print("ready...")
        realStateTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("length here = \(allRealStateList.count)")
        return allRealStateList.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="details" {
            let indexPath : NSIndexPath = realStateTableView.indexPathForSelectedRow!
            currentRealState = allRealStateList[indexPath.row]
            let realStateDetails : RealStateDetails = segue.destinationViewController as! RealStateDetails
            realStateDetails.realState = currentRealState
        } else if segue.identifier == "NoRealEstateFavorite"{
            let vc = segue.destinationViewController
            vc.navigationItem.hidesBackButton = true
            vc.modalPresentationStyle = .OverFullScreen
        } else if segue.identifier == "NoDataFound"{
            let vc = segue.destinationViewController as! NoData
            vc.navBarTitle = "My Real Estate"
            vc.modalPresentationStyle = .OverFullScreen
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("rendering...")
        let cell = tableView.dequeueReusableCellWithIdentifier("realStateCell", forIndexPath: indexPath)
        
        let indicator = UIImage(named: "arrow-icon")
        cell.accessoryType = .DisclosureIndicator
        cell.accessoryView = UIImageView(image: indicator!)
        
        
        rSImage = cell.viewWithTag(20) as! UIImageView
        rSTitle = cell.viewWithTag(21) as! UILabel
        rSDate = cell.viewWithTag(22) as! UILabel
        rSLocation = cell.viewWithTag(23) as! UILabel
        rSPrice = cell.viewWithTag(24) as! UILabel
        
        let realStateObject : PORealState = allRealStateList[indexPath.row]
        print(realStateObject.rsTitle)
        rSTitle.text = realStateObject.rsTitle
        rSDate.text = realStateObject.createionDate
        rSLocation.text = realStateObject.rsLocation
        rSPrice.text = String(realStateObject.rsPrice!)+" EGP"
        
        if !(realStateObject.coverImage?.isEmpty(realStateObject.coverImage!))! {
            print("not empty")
            print("URL = \(realStateObject.coverImage)")
            NetworkManager.loadImage(realStateObject.coverImage!, completionHandler: { (data) in
                self.rSImage.image = UIImage(data: data);
            })
        } else{
            print("empty")
        }
        
        //        print("Welcome")
        //        if !(realStateObject.coverImage?.containsWhiteSpace())! {
        //            NetworkManager.loadImage(realStateObject.coverImage!, completionHandler: { (data) in
        //                self.rSImage.image = UIImage(data: data);
        //            })
        //        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        currentRealState = allRealStateList[indexPath.row]
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        currentRealState = allRealStateList[indexPath.row]
        if currentRealState.isOwner==1 {
            return true
        } else {
            return false
        }
    }
    
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            currentIndex = indexPath.row
            if type==JeeranUtil.REALESTATE_FAVORITE {
                serviceLayer.deleteFavoriteRealState(allRealStateList[indexPath.row].favId)
            } else{
                serviceLayer.deleteRealState(allRealStateList[indexPath.row].id!)
            }
            
            allRealStateList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            decideWhatToDoAfterDelete()
        }
    }
    
    func commitSuccess(){
        let alertController = UIAlertController(title: JeeranUtil.successTitle, message: JeeranUtil.successMsg, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) { }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func notifyNoDataExist(){
        
        
        if type == JeeranUtil.MY_REALESTATE {
            toggleNetworkLoading(false)
            self.performSegueWithIdentifier("NoDataFound", sender: self)
        } else if type == JeeranUtil.REALESTATE_FAVORITE {
            toggleNetworkLoading(false)
            self.performSegueWithIdentifier("NoRealEstateFavorite", sender: self)
        }
    }
    
    func setImageFeaturesList(imgFeatures : Array<PORealStateImages>){
        imageFeaturesList = imgFeatures
        
        enableAutoScrollView()
        configureScrollImages()
        loadScrollViewImages()
    }
    
    func configureScrollImages(){
        scrollView.auk.settings.contentMode = .ScaleAspectFill
        scrollView.auk.settings.placeholderImage = UIImage(named: "logo")
    }
    
    func loadScrollViewImages(){
        if imageFeaturesList.count>0{
            loadRemoteImages()
        } else{
            loadLocalImages()
        }
    }
    
    func loadRemoteImages(){
        for i in 0..<imageFeaturesList.count{
            let url : String = imageFeaturesList[i].coverImage
            scrollView.auk.show(url:url,accessibilityLabel: imageFeaturesList[i].title)
        }
    }
    
    func loadLocalImages(){
        let image = UIImage(named:"logo")
        for _ in 0...2{
            scrollView.auk.show(image:image!)
        }
    }
    
    func enableAutoScrollView(){
        scrollView.auk.startAutoScroll(delaySeconds: 3)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
