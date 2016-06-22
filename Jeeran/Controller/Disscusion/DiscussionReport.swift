//
//  DiscussionReport.swift
//  Jeeran
//
//  Created by Mac on 6/13/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class DiscussionReport: UIViewController,UITextViewDelegate {

    var reportReasonsList : Array<POReportReasons> = []
    var serviceLayer : SLDiscussion!
    var reportServiceLayer : SLReport!
    var reasonId : Int!
    var reportTypeId : Int!
    var reportId : Int!
    var selectedReason : POReportReasons!
    var placeHolder : String = "add your Report here"

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var networkWaiting: UIActivityIndicatorView!
    @IBOutlet weak var reportDetails: UITextView!
    @IBOutlet weak var reasonsView: UIButton!
    
    let userImageUrl = (UIApplication.sharedApplication().delegate as! AppDelegate).user.imageUrl

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.removeBackBarButtonItem()
        reportDetails.delegate = self
        serviceLayer = SLDiscussion.getInstance(self,type: 1)
        reportServiceLayer = SLReport.getInstance(self, type: 0)
        serviceLayer.getRepotReasons()
        
        NetworkManager.loadImage(userImageUrl, completionHandler: { (data) in
            self.userImage.image = UIImage(data: data);
        })

        // Do any additional setup after loading the view.
    }

    func toggleNetworkAnimator(flag : Int){
        if flag==1 { //start animation
            networkWaiting.startAnimating()
        } else{ //stop animating
            networkWaiting.stopAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setReportReasonsList(reasons : Array<POReportReasons>){
        reportReasonsList = reasons
        reasonId = reportReasonsList[0].id
    }

    @IBAction func showReportReasonTypes(sender: AnyObject) {
        let reasonActionSheet : UIAlertController = UIAlertController(title: "Please select a reason", message: "Reason to select", preferredStyle: .ActionSheet)
        for reason in reportReasonsList{
            reasonActionSheet.addAction(UIAlertAction(title: reason.reasonEn, style: .Default, handler: { (topicActionSheetClosure) in
                self.selectedReason = reason
                self.reasonId = self.selectedReason.id
                self.reasonsView.setTitle(self.selectedReason.reasonEn, forState: .Normal)
            }))
        }
        reasonActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
        }))
        self.presentViewController(reasonActionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func postReport(sender: AnyObject) {
        if reportDetails.text.isEmpty(reportDetails.text) || reportDetails.text==placeHolder{
            reportDetails.changeBorderColor(reportDetails, empty: true,msg: placeHolder)
        } else{
            toggleNetworkAnimator(1)
            reportDetails.changeBorderColor(reportDetails, empty: false,msg:"")
            reportServiceLayer.postReport(reasonId, reportType: reportTypeId, reportId: reportId, message: reportDetails.text)
        }
    }
    
    func showResponseMessage(title : String,msg : String){
        toggleNetworkAnimator(0)
        let alertController = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) { }
        reportDetails.text = placeHolder
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if reportDetails.text==placeHolder {
            reportDetails.text = ""
        }
    }
    func textViewDidEndEditing(textView: UITextView){
        if reportDetails.text == "" {
            reportDetails.text = placeHolder
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

}
