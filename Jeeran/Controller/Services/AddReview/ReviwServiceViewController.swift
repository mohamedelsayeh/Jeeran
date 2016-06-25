//
//  ReviwServiceViewController.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/26/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class ReviwServiceViewController: UIViewController {
    
    @IBOutlet weak var rate: UITextField!
    @IBOutlet weak var review: UITextField!
    var serviceName :String?
    var service_place_id : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func add(sender: AnyObject) {
        if rate.text == ""
        {
            
            let alert = UIAlertController(title: "Services", message: "Enter rate please", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else if review.text == ""
        {
            let alert = UIAlertController(title: "Services", message: "Enter review please", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        else
        {
            WebserviceManager.addReviwServicesPlace(ServicesURLs.serviceReviewAddURL(), header: ["Authorization": ServicesURLs.token], parameters: ["service_place_id":1,"review" : review.text!,"Rating" : rate.text!], result: { (serviceResponse, code) in
                if serviceResponse.success! == true
                {
                    let alert = UIAlertController(title: "Services", message: "Add Review  ", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                else{
                    let alert = UIAlertController(title: "Services", message: "No Review added ", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            self.navigationController?.popViewControllerAnimated(true)
            //  self.performSegueWithIdentifier("backReviews", sender: self)
            
        }
        
    }
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "backReviews"
    //        {
    //            let view = segue.destinationViewController as! ServiceRate
    //            view.serviceName = self.serviceName
    //            view.service_place_id = self.service_place_id
    //        }
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
