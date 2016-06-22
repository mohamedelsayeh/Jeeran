//
//  RealStateDetails.swift
//  Jeeran
//
//  Created by Mac on 6/9/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import Auk

class RealStateDetails: UIViewController,UIScrollViewDelegate {
    
    var realState : PORealState!
    
    @IBOutlet weak var rsTitle: UILabel!
    @IBOutlet weak var rsDate: UILabel!
    @IBOutlet weak var rsLocation: UILabel!
    @IBOutlet weak var rsPrice: UILabel!
    @IBOutlet weak var rsDetails: UITextView!
    @IBOutlet weak var rsArea: UILabel!
    @IBOutlet weak var rsBathRooms: UILabel!
    @IBOutlet weak var rsBedRooms: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.removeBackBarButtonItem()
        
        retrieveRealStateDetails()
        enableAutoScrollView()
        configureScrollImages()
        loadScrollViewImages()
    }
    
    func configureScrollImages(){
        scrollView.auk.settings.contentMode = .ScaleAspectFill
        scrollView.auk.settings.placeholderImage = UIImage(named: "logo")
    }
    
    func loadScrollViewImages(){
        let detailsImages = realState.realEstateAdImage! as Array<NSDictionary>
        if detailsImages.count>0{
            loadRemoteImages(detailsImages)
        } else if !(realState.coverImage?.isEmpty(realState.coverImage!))! {
            for _ in 0...2{
                scrollView.auk.show(url: realState.coverImage!)
            }
        } else{
            loadLocalImages()
        }
    }
    
    func loadRemoteImages(detailsImages : Array<NSDictionary>){
        for i in 0..<detailsImages.count{
            let url : String = detailsImages[i].objectForKey("originalimg") as! String
            scrollView.auk.show(url:url)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveRealStateDetails(){
        rsTitle.text = realState.rsTitle
        rsDate.text = realState.createionDate
        rsLocation.text = realState.rsLocation
        rsPrice.text = String(realState.rsPrice!)+" EGP"
        rsDetails.text = realState.description
        rsArea.text = realState.area
        rsBathRooms.text = String(realState.numOfBathRooms)
        rsBedRooms.text = String(realState.numOfRooms!)
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
