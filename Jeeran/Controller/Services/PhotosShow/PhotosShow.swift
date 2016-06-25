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
class PhotosShow: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageNames = [Image]()
    var mainServicesCategory = [ResponseService]()
    var index : Int?
    var nameOfService : String?
    
    override func viewDidLoad() {
           scrollView.delegate = self
        
        print("ffffffffffddfffff",imageNames.count)
                print("ffffffffffddfffff",(imageNames[0].origninal)!)
//        WebserviceManager.getServiceImages(ServicesURLs.servicePlaceImageFeatureURL(), header:["Authorization": ServicesURLs.token], parameters: [:],result: { (images:[String],code:String?) -> Void in
//            self.imageNames = images
           self.onShowRemoteTapped()
           self.onAutoscrollTapped()
//            }
//        )
        
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
            var i :Int = 0
            for i in 0..<imageNames.count{
            print("here",(imageNames[i].origninal)!)
                let url =  (imageNames[i].origninal)!
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
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation,   duration: NSTimeInterval) {
        
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        var screenWidth = UIScreen.mainScreen().bounds.height
        if UIInterfaceOrientationIsPortrait(toInterfaceOrientation) {
            screenWidth = UIScreen.mainScreen().bounds.width
        }
        
        guard let pageIndex = scrollView.auk.currentPageIndex else { return }
        scrollView.auk.scrollTo(pageIndex, pageWidth: screenWidth, animated: false)
    }
    
    private func changeCurrentImageDescription(description: String) {
           }
    
    @IBAction func Back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}

