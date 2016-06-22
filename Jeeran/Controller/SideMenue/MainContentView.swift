//
//  MainContentView.swift
//  Jeeran
//
//  Created by Mohammed on 6/4/16.
//  Copyright © 2016 Information Technology Institute. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton
import Auk

class MainContentView: UIViewController, FloatingButtonDelegate,ResponseManager {
    
    @IBOutlet weak var btnServices: UIButton!
    @IBOutlet weak var btnDiscussion: UIButton!
    @IBOutlet weak var btnRealEstate: UIButton!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var imageFeaturesList : Array<PORealStateImages> = []
    var networkManager : NetworkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideMenuController()?.addLeftBarButtonWithImage(UIImage(named:"nav-icon")!)
        btnServices.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 20)
        btnServices.imageView?.contentMode = .ScaleAspectFit
        btnDiscussion.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 20)
        btnDiscussion.imageView?.contentMode = .ScaleAspectFit
        btnRealEstate.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 20)
        btnRealEstate.imageView?.contentMode = .ScaleAspectFit
        
        lblPlace.text = (UIApplication.sharedApplication().delegate! as! AppDelegate).place
        networkManager = NetworkManager()
        networkManager.caller = self
        networkManager.connectTo("realstate/imagefeature",header: ["":""],parameters: ["":""],state: 10)
        
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
    
    override func viewWillAppear(animated: Bool) {
        self.title = "Main"
    }
    override func viewDidAppear(animated: Bool) {
        (self.navigationController as! FloatingNavigationController).viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ServicesTappedOn(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "MainServices", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Services") as! Discussion
        vc.type = JeeranUtil.DISCUSSION
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func discussionTappedOn(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Discussion") as! Discussion
        vc.type = JeeranUtil.DISCUSSION
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func realStateTappedOn(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("RealEstate") as! RealState
        vc.type = JeeranUtil.REALESTATE
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        switch index {
        case 3:
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController((storyboard?.instantiateViewControllerWithIdentifier("AddRealEstateView"))!, animated: true)
            break
        default:
            break
        }
        liquidFloatingActionButton.close()
    }
    
    func floatingButtonDidSelectRowAt(index: Int) {
        switch index {
        case 1:
            break
        case 2:
            break
        case 3:
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController((storyboard?.instantiateViewControllerWithIdentifier("AddRealEstateView"))!, animated: true)
            break
        case 4:
            break
        default:
            break
        }
    }
    
    
    func receiveResponse(response:AnyObject,rState:Int){
        processImageFeatureResponse(response)
    }
    
    func processImageFeatureResponse(response:AnyObject){
        let json = response as! [String: AnyObject]
        let imgFeatureList : NSArray = json["response"]! as! NSArray
        imageFeaturesList.removeAll()
        var imageFeatureObj: PORealStateImages!
        for imgFeature in imgFeatureList {
            imageFeatureObj = PORealStateImages()
            imageFeatureObj.coverImage = imgFeature.objectForKey("cover_image") as! String
            imageFeatureObj.title = imgFeature.objectForKey("title") as! String
            self.imageFeaturesList.append(imageFeatureObj)
        }
        setImageFeaturesList(imageFeaturesList)
    }
    
    
}
