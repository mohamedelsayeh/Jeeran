//
//  detailServiceViewController.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/9/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class DetailServiceViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    private var papersDataSource = PapersDataSource()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var allReviews: UIButton!
    @IBOutlet weak var loc: UIButton!
    @IBOutlet weak var callUs: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var openHour: UILabel!
    @IBOutlet weak var rateS: UILabel!
    @IBOutlet weak var serviceAddress: UILabel!
    @IBOutlet weak var aboutServiceName: UILabel!
    var main_Service_id : Int?
    var sub_service_id : Int?
    var  serviceName : String?
    var serviceShow : ResponseShowServicePlace?
    var servicesPlace = [ResponseServiceList]()
    var servicesReview = [Review]()
    var latitude :Double?
    var longitude :Double?
    override func viewDidLoad() {
        
        self.navigationItem.title = serviceName
        self.textView.contentOffset.y = 0
        self.allReviews.layer.cornerRadius = 5.0;
        self.callUs.layer.cornerRadius = 5.0;
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailServiceViewController.labelTapped(_:)))
        locationLabel.addGestureRecognizer(tapRecognizer)
        //  loc.addGestureRecognizer(tapRecognizer)
        WebserviceManager.showServicesPlace("http://jeeran.gn4me.com/jeeran_v1/serviceplace/show", header:["Authorization": ServicesURLs.token], parameters: ["service_place_id":sub_service_id!],result: { (servicesPlace :ResponseShowServicePlace,code:String?) -> Void in
            self.serviceShow = servicesPlace
            self.name.text = self.serviceShow?.servicePlace?[0].title
            self.rateS.text = String((self.serviceShow?.servicePlace?[0].total_rate)!)
            self.aboutServiceName.text = "About "+(self.serviceShow?.servicePlace?[0].title)!
            
            print("rating value ", String((self.serviceShow?.servicePlace?[0].total_rate)!))
            
            WebserviceManager.getImage( (self.serviceShow?.servicePlace?[0].cover_image)! , result: { (image, code) in
                self.serviceImage.image = image
            })
            
            
            self.openHour.text =  self.serviceShow?.servicePlace?[0].opening_hours
            self.serviceAddress.text = self.serviceShow?.servicePlace?[0].address
            self.textView.text = self.serviceShow?.servicePlace?[0].description
            self.servicesReview = (self.serviceShow?.review)!
            print("latitute",(self.serviceShow?.servicePlace?[0].latitude)!)
            self.latitude = (self.serviceShow?.servicePlace?[0].latitude)!
            self.longitude = (self.serviceShow?.servicePlace?[0].longitude)!
            print("ddddd",self.servicesReview.count)
            print("ddddd",self.servicesReview[0].created_at!)
            WebserviceManager.getImage((self.serviceShow?.servicePlace?[0].logo)!, result: { (image, code) in
                self.serviceImage.image = image
            })
            }
        )
        WebserviceManager.getServicesPlaceList(ServicesURLs.servicePlaceListURL(), header:["Authorization": ServicesURLs.token], parameters: ["service_sub_category_id":main_Service_id!],result: { (servicesPlace :[ResponseServiceList],code:String?) -> Void in
            self.servicesPlace = servicesPlace
            print("ghhhhh",servicesPlace.count,"ffffid ",self.main_Service_id!)
            PapersDataSource.subServicesCategory = servicesPlace
            print("PapersDataSource.subServicesCategory",PapersDataSource.subServicesCategory.count)
            self.collectionView.reloadData()
            print("here")
            }
        )
        
        //        WebserviceManager.getSubServices("http://jeeran.gn4me.com/jeeran_v1/serviceplacecategory/list",header:["Authorization": ServicesURLs.token], parameters: ["main_category":1],result: {(mainServices :[ResponseSubServices],code:String?)->Void
        //            in
        //         //   self.subServicesCategory = mainServices
        //            print("here",mainServices.count)
        //            self.collectionView.reloadData()
        //            PapersDataSource.subServicesCategory = mainServices
        //        })
        // Do any additional setup after loading the view.
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        self.collectionView.reloadData()
    }
    
    
    func labelTapped(gestureRecognizer: UITapGestureRecognizer) {
        loc.imageView?.image = UIImage(named: "location-icon-active")
        
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //  let tappedImageView = gestureRecognizer.view!
        //     let storyBoard = UIStoryboard(name: "MainServices", bundle: nil)
        //          let mapController = storyboard!.instantiateViewControllerWithIdentifier("MapController") as MapController
        //
        //        self.navigationController.pushViewController(secondViewController, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "serviceReview"
        {
            let view = segue.destinationViewController as! ServiceRate
            view.servicesReview = servicesReview
        }
        if segue.identifier == "ServiceMap"
        {
            let view = segue.destinationViewController as! MapController
            view.latitude = self.latitude
            view.longitude = self.longitude
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let kWhateverHeightYouWant = 145
        return CGSizeMake(collectionView.bounds.size.width/3, CGFloat(kWhateverHeightYouWant))
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //CollectionView
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("papersDataSource.count",papersDataSource.count)
        //return papersDataSource.count
        return servicesPlace.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        
        var paper : Paper?
        print("=====================",PapersDataSource.subServicesCategory.count)
        if servicesPlace.count == 0
        {
            paper = Paper(caption: "ddd", section: "1", index: 1,rate: 3,name: "Sun Moll")
            
            WebserviceManager.getImage("http://static1.yellow-pages.ph/business_photos/438185/sun_mall_thumbnail.png" , result: { (image, code) in
                paper!.imageName = image
                self.collectionView.reloadData()
            })
            
        }
        else
        {
            //  print("heraratenig",self.servicesPlace[indexPath.row].)
            //  for subService in PapersDataSource.subServicesCategory {
            paper = Paper(caption: "ddd", section: "1", index: 1,rate:3 ,name: self.servicesPlace[indexPath.row].title!)
            print("image", self.servicesPlace[indexPath.row].logo!)
            WebserviceManager.getImage( self.servicesPlace[indexPath.row].logo! , result: { (image, code) in
                paper!.imageName = image
                print(image)
            })
        }
        //   }
        //        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
        cell.paper = paper
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.grayColor().CGColor
        //            //Color().CGColor
        //            //e6e6e8
        //        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //  if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
        let viewDetailService =  self.storyboard?.instantiateViewControllerWithIdentifier("DetailsSubView") as! DetailServiceViewController
        viewDetailService.main_Service_id = main_Service_id!
        viewDetailService.sub_service_id = self.servicesPlace[indexPath.row].service_place_id!
        viewDetailService.serviceName = serviceName
        print(serviceName)
        self.navigationController?.pushViewController(viewDetailService, animated: true)
        // }
    }
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        if segue.identifier=="MasterToDetail" {
    //
    //            let view =  DetailServiceViewController()
    //            view.main_Service_id = 1
    //            view.serviceName = serviceName
    //            self.navigationController?.pushViewController(view, animated: true)
    ////            let subService = segue.destinationViewController as! SubServices
    ////            subService.main_Service_id = index!
    ////            subService.serviceName = nameOfService
    //        }
    //    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "MasterToDetail" {
    //            let detailViewController = segue.destinationViewController as! DetailViewController
    //            detailViewController.paper = sender as? Paper
    //            detailViewController
    //        }
    //    }
    
    
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
