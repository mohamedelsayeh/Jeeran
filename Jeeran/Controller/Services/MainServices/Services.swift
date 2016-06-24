//
//  Services.swift
//  Jeeran
//
//  Created by Mac on 5/24/16.
//  Copyright © 2016 Mac. All rights reserved.
//
import UIKit
import Auk
import moa
class Services: UIViewController, UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    // var mainServices = ResponseService()
    var names = [ "Food and Beverages", "Shopping"]
    var images = [UIImage(named:"food-icon") ,UIImage(named:"shopping-icon")]
    var imageNames = [String]()
    var mainServicesCategory = [ResponseService]()
    var notification = [12,33,23]
    var imageDescriptions = [String]()
    
    var index : Int?
    var nameOfService : String?
    
    override func viewDidLoad() {
        tableView.hidden = true
        serviceIcon = UIImageView(image: UIImage(named: "services-active")!)
     //   serviceIcon.image = UIImage(named: "services-active.png")!
        scrollView.delegate = self
        WebserviceManager.getServiceImages(ServicesURLs.servicePlaceImageFeatureURL(), header:["Authorization": ServicesURLs.token], parameters: [:],result: { (images:[String],code:String?) -> Void in
            self.imageNames = images
            self.onShowRemoteTapped()
            self.onAutoscrollTapped()
            }
        )
        
        WebserviceManager.getMainServices("http://jeeran.gn4me.com/jeeran_v1/serviceplacecategory/list",header:["Authorization": ServicesURLs.token], parameters: [:],result: {(mainServices :[ResponseService],code:String?)->Void
            in
            self.mainServicesCategory = mainServices
            print("here",self.mainServicesCategory.count)
            self.tableView.hidden = false
            self.tableView.reloadData()
            
        })
        UITabBar.appearance().backgroundColor = UIColor.blackColor()
        scrollView.delegate = self
        scrollView.auk.settings.placeholderImage = UIImage(named: "great_auk_placeholder.png")
        scrollView.auk.settings.errorImage = UIImage(named: "error_image.png")
        //        self.onShowRemoteTapped()
        //        self.onAutoscrollTapped()
        showInitialImage()
        print("here",self.mainServicesCategory.count)
        super.viewDidLoad()
    }
    
    // Show the first image when the app starts
    private func showInitialImage() {
        if let image = UIImage(named: ConstantsURLS.initialImage.fileName) {
            scrollView.auk.show(image: image,
                                accessibilityLabel: ConstantsURLS.initialImage.description)
        }
    }
    
    func onShowRemoteTapped() {
        
      //  scrollView.auk.stopAutoScroll()
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
    
    func onAutoscrollTapped( ) {
        scrollView.auk.startAutoScroll(delaySeconds: 2)
    }
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
    
    //table part
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.mainServicesCategory.count==0)
        {return 2;}
        else
        {return self.mainServicesCategory.count;}
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! TableViewCell
        
        // print(self.mainServices[0].title)
        //         print("here",self.mainServices[0].title_en!)
        if(self.mainServicesCategory.count==0)
        {
            cell.cellImage.image = images[indexPath.row]
            cell.labelCell.text = names[indexPath.row]
            cell.cellNotification.titleLabel?.text = String( notification[indexPath.row])
        }
        else{
            WebserviceManager.getImage( self.mainServicesCategory[indexPath.row].logo! , result: { (image, code) in
                cell.cellImage.image = image
            })
            //            var url = mainServices[indexPath.row].logo
            //            cell.cellImage.image =
            cell.labelCell.text = self.mainServicesCategory[indexPath.row].title_en!
            cell.cellNotification.titleLabel?.text = String( self.mainServicesCategory[indexPath.row].subcats!)
            
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.mainServicesCategory.count != 0)
        {
            index = indexPath.row + 1
            nameOfService = self.mainServicesCategory[indexPath.row].title_en!
            self.performSegueWithIdentifier("subService", sender: self)
            //        let subService = SubServices()
            //        subService.main_Service_id = index!
            //        self.navigationController?.pushViewController(subService, animated: false)
        }
        else
        {
            self.performSegueWithIdentifier("subService", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier=="subService" {
            if self.mainServicesCategory.count != 0
            {
                let subService = segue.destinationViewController as! SubServices
            subService.main_Service_id = index!
            subService.serviceName = nameOfService
            }
            else{
             let subService = segue.destinationViewController as! SubServices
            }
        }
    }
    @IBAction func Back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

