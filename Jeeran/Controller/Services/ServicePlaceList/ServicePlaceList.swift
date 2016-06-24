//
//  SupermarketServices.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/9/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
class ServicePlaceList: UIViewController,UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var indexOfView : Int?
    var imageNames = [String]()
    var servicesPlace = [ResponseServiceList]()
    var names = [ "Grand Market", "Carfoure"]
    var images = [UIImage(named:"cortigianoRestaurant"),UIImage(named:"location-icon") ]
    var notification = [12,33,23]
    var imageDescriptions = [String]()
    var main_Service_id : Int?
    var id : Int?
    var serviceName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = serviceName
        UITabBar.appearance().backgroundColor = UIColor.blackColor()
        scrollView.delegate = self
        WebserviceManager.getServiceImages(ServicesURLs.servicePlaceImageFeatureURL(), header:["Authorization": ServicesURLs.token], parameters: [:],result: { (images:[String],code:String?) -> Void in
            self.imageNames = images
            self.onShowRemoteTapped()
            self.onAutoscrollTapped()
            }
        )
  
        print("========>main_Service_id:",main_Service_id!)
        WebserviceManager.getServicesPlaceList(ServicesURLs.servicePlaceListURL(), header:["Authorization": ServicesURLs.token], parameters: ["service_sub_category_id": main_Service_id!],result: { (servicesPlace :[ResponseServiceList],code:String?) -> Void in
            self.servicesPlace = servicesPlace
            print("here",self.servicesPlace.count)
            self.tableView.hidden = false
            self.tableView.reloadData()
            }
        )
        
        //        WebserviceManager.getSubServices("http://jeeran.gn4me.com/jeeran_v1/serviceplacecategory/list",header:["Authorization": ServicesURLs.token], parameters: ["main_category":main_Service_id!],result: {(mainServices :[ResponseSubServices],code:String?)->Void
        //            in
        //            self.subServicesCategory = mainServices
        //            print("here",self.subServicesCategory.count)
        //            self.tableView.hidden = false
        //            self.tableView.reloadData()
        //
        //        })
        showInitialImage()
        //    showCurrentImageDescription()
    }
    
    // Show the first image when the app starts
    private func showInitialImage() {
        if let image = UIImage(named: ConstantsURLS.initialImage.fileName) {
            scrollView.auk.show(image: image,
                                accessibilityLabel: ConstantsURLS.initialImage.description)
            
            //   imageDescriptions.append(DemoConstants.initialImage.description)
        }
    }
    
    // Show local images
    //    @IBAction func onShowLocalTapped(sender: AnyObject) {
    //        scrollView.auk.stopAutoScroll()
    //        for localImage in DemoConstants.localImages {
    //            if let image = UIImage(named: localImage.fileName) {
    //                scrollView.auk.show(image: image, accessibilityLabel: localImage.description)
    //                imageDescriptions.append(localImage.description)
    //            }
    //        }
    //
    //        showCurrentImageDescription()
    //    }
    
    // Show remote images
    func onShowRemoteTapped() {
        
        scrollView.auk.stopAutoScroll()
        if(imageNames.count==0)
        {
            self.onShowLocalTapped()
        }
        else{
            for remoteImage in imageNames{
                let url =  remoteImage
                scrollView.auk.show(url: url, accessibilityLabel:"")
            }
        }
    }
    func onShowLocalTapped() {
        scrollView.auk.stopAutoScroll()
        for localImage in ConstantsURLS.localImages {
            if let image = UIImage(named: localImage.fileName) {
                scrollView.auk.show(image: image, accessibilityLabel: localImage.description)
                //   imageDescriptions.append(localImage.description)
            }
        }
        
    }
    //  func onShowRemoteTapped() {
    //        scrollView.auk.stopAutoScroll()
    //        for remoteImage in ConstantsURLS.remoteImages {
    //            let url =  "\(ConstantsURLS.remoteImageBaseUrl)\(remoteImage.fileName)"
    //            scrollView.auk.show(url: url, accessibilityLabel: remoteImage.description)
    //            //   imageDescriptions.append(remoteImage.description)
    //        }
    
    // showCurrentImageDescription()
    //  }
    
    // Scroll to the next image
    //    @IBAction func onShowRightButtonTapped(sender: AnyObject) {
    //        scrollView.auk.stopAutoScroll()
    //
    //        if RightToLeft.isRightToLeft(view) {
    //            scrollView.auk.scrollToPreviousPage()
    //        } else {
    //            scrollView.auk.scrollToNextPage()
    //        }
    //    }
    //
    //    // Scroll to the previous image
    //    @IBAction func onShowLeftButtonTapped(sender: AnyObject) {
    //        scrollView.auk.stopAutoScroll()
    //
    //        if RightToLeft.isRightToLeft(view) {
    //            scrollView.auk.scrollToNextPage()
    //        } else {
    //            scrollView.auk.scrollToPreviousPage()
    //        }
    //    }
    
    // Remove all images
    //    @IBAction func onDeleteButtonTapped(sender: AnyObject) {
    //        scrollView.auk.stopAutoScroll()
    //        scrollView.auk.removeAll()
    //        imageDescriptions = []
    //        showCurrentImageDescription()
    //    }
    func onAutoscrollTapped( ) {
        scrollView.auk.startAutoScroll(delaySeconds: 2)
    }
    
    
    
    //    private func layoutButtons() {
    //        layoutButtons(leftButton, secondView: autoScrollButton)
    //        layoutButtons(autoScrollButton, secondView: rightButton)
    //    }
    
    // Use left/right constraints instead of leading/trailing to prevent buttons from changing their place for right-to-left languages.
    private func layoutButtons(firstView: UIView, secondView: UIView) {
        let constraint = NSLayoutConstraint(
            item: secondView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: firstView,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1,
            constant: 35)
        
        view.addConstraint(constraint)
    }
    
    // MARK: - Handle orientation change
    
    /// Animate scroll view on orientation change
    override func viewWillTransitionToSize(size: CGSize,
                                           withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        guard let pageIndex = scrollView.auk.currentPageIndex else { return }
        let newScrollViewWidth = size.width // Assuming scroll view occupies 100% of the screen width
        
        coordinator.animateAlongsideTransition({ [weak self] _ in
            self?.scrollView.auk.scrollTo(pageIndex, pageWidth: newScrollViewWidth, animated: false)
            }, completion: nil)
    }
    
    /// Animate scroll view on orientation change
    /// Support iOS 7 and older
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation,
                                                   duration: NSTimeInterval) {
        
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        var screenWidth = UIScreen.mainScreen().bounds.height
        if UIInterfaceOrientationIsPortrait(toInterfaceOrientation) {
            screenWidth = UIScreen.mainScreen().bounds.width
        }
        
        guard let pageIndex = scrollView.auk.currentPageIndex else { return }
        scrollView.auk.scrollTo(pageIndex, pageWidth: screenWidth, animated: false)
    }
    
    // MARK: - Image description
    
    //    private func showCurrentImageDescription() {
    //        if let description = currentImageDescription {
    //            imageDescriptionLabel.text = description
    //        } else {
    //            imageDescriptionLabel.text = nil
    //        }
    //    }
    
    private func changeCurrentImageDescription(description: String) {
        guard let currentPageIndex = scrollView.auk.currentPageIndex else { return }
        
        if currentPageIndex >= imageDescriptions.count {
            return
        }
        
        imageDescriptions[currentPageIndex] = description
        //  showCurrentImageDescription()
    }
    
    private var currentImageDescription: String? {
        guard let currentPageIndex = scrollView.auk.currentPageIndex else { return nil }
        
        if currentPageIndex >= imageDescriptions.count {
            return nil
        }
        
        return imageDescriptions[currentPageIndex]
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //  showCurrentImageDescription()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75;
    }
    //table part
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.servicesPlace.count==0)
        {return 0;}
        else
        {return self.servicesPlace.count;}
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = self.tableView.dequeueReusableCellWithIdentifier("serviceCell",forIndexPath: indexPath) as! SubServiceCell
        //        return cell
        
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("serviceCell",forIndexPath: indexPath) as! SubServiceCell
        
        // print(self.mainServices[0].title)
        //         print("here",self.mainServices[0].title_en!)
        if(self.servicesPlace.count==0)
        {
            //            cell.locationImage.image = images[indexPath.row+1]
            //            cell.cellName.text = names[indexPath.row]
            //            cell.imageCell.image = images[indexPath.row]
            //
            //            cell.cellImage.image = images[indexPath.row]
            //            cell.labelCell.text = names[indexPath.row]
            //            cell.cellNotification.titleLabel?.text = String( notification[indexPath.row])
        }
        else{
            WebserviceManager.getImage( self.servicesPlace[indexPath.row].logo! , result: { (image, code) in
                cell.imageCell.image = image
            })
            //   cell.locationImage.image = images[indexPath.row+1]
            cell.cellName.text = self.servicesPlace[indexPath.row].title!
   //         id = self.servicesPlace[indexPath.row].service_place_id!
         //   print("index ", self.servicesPlace[indexPath.row].service_place_id!)

            //     cell.imageCell.image = images[indexPath.row]
            
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     //  print("index of DEtails",self.servicesPlace[indexPath.row].service_place_id!)
    indexOfView = self.servicesPlace[indexPath.row].service_place_id!
//        print("index of DEtails",indexOfView!)
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
            detailService.sub_service_id = indexOfView
        }
    }
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


