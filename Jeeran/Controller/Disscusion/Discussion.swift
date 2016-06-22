//
//  Discussion.swift
//  Jeeran
//
//  Created by Mac on 5/29/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Discussion: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var userImage: UIImageView!
    var discName : UILabel!
    var discDate : UILabel!
    var discTitle : UILabel!
    var discImage : UIImageView!
    var discPersonImage : UIImageView!
    var discDetails : UITextView!
    var favIcon : UIImageView!
    var discussionObj : PODiscussion!
    var allDiscussionList : Array<PODiscussion> = []
    var topicsList : Array<POTopic> = []
    var discDetailsTemp : String!
    var currentDiscussion : PODiscussion!
    var selectedTopic : POTopic!
    var serviceLayer : SLDiscussion!
    var commentsView : Comments!
    var commentAddingButton  : UIButton!
    var activeCell : UITableViewCell!
    var imagePicker : UIImagePickerController!
    var discImageBytes : NSMutableArray = []
    var discImageToUpload:NSData! = nil
    var currentIndex : Int!
    var placeHolder : String = "add your Discussion here"
    var type : Int = 1
    var userId : Int!
    var neighborId : Int!
    
    @IBOutlet weak var networkWaiting: UIActivityIndicatorView!
    @IBOutlet weak var uploadedImageView: UIImageView!
    @IBOutlet weak var imageDelete: UIButton!
    @IBOutlet weak var topicView: UIButton!
    @IBOutlet weak var discussionDetails: UITextView!
    
    @IBOutlet weak var postsContainerView: UIView!
    @IBOutlet weak var actionsContainerView: UIView!
    @IBOutlet weak var discussionTableView: UITableView!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    let userImageUrl = (UIApplication.sharedApplication().delegate as! AppDelegate).user.imageUrl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.removeBackBarButtonItem()
        discussionDetails.delegate = self
        toggleUploadedImageView(true)
        serviceLayer = SLDiscussion.getInstance(self,type: 0)
        toggleNetworkAnimator(1)
        
        userId = (UIApplication.sharedApplication().delegate as! AppDelegate).user.userId
        neighborId = (UIApplication.sharedApplication().delegate as! AppDelegate).user.neighborhoodId
        
        if type == JeeranUtil.MY_DISCUSSION || type == JeeranUtil.DISCUSSION_FAVORITE {
            tableTopConstraint.constant = -(self.view.frame.size.height-discussionTableView.frame.size.height)
        }
        
        
        NetworkManager.loadImage(userImageUrl, completionHandler: { (data) in
            self.userImage.image = UIImage(data: data);
        })

        getDataList()
    }
    
    func getDataList(){
        if type == JeeranUtil.DISCUSSION {
            self.title = "Discussion"
            serviceLayer.getDiscussionList(0)
        } else if type == JeeranUtil.MY_DISCUSSION{
            self.title = "My Discussion"
            serviceLayer.getMyDiscussionList()
        } else if type == JeeranUtil.DISCUSSION_FAVORITE{
            print("Getting Favorites")
            serviceLayer.getDiscussionFavoriteList()
        }
    }
    
    @IBAction func deleteUploadedImage(sender: AnyObject) {
        resetVariables()
        toggleUploadedImageView(true)
    }
    func toggleUploadedImageView(flag : Bool){
        uploadedImageView.hidden = flag
        imageDelete.hidden = flag
    }

    func toggleNetworkAnimator(flag : Int){
        if flag==1 { //start animation
            networkWaiting.startAnimating()
        } else{ //stop animating
            networkWaiting.stopAnimating()
        }
    }
    
    func setDiscussionList(allDiscussionList : Array<PODiscussion>){
        toggleNetworkAnimator(0)
        self.allDiscussionList.removeAll()
        self.allDiscussionList = allDiscussionList
        self.discussionTableView.reloadData()
    }
    
    func setTopicList(topics : Array<POTopic>){
        topicsList = topics
        selectedTopic = topicsList[0]
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
        return self.allDiscussionList.count
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("discussCell", forIndexPath: indexPath)
        discPersonImage = cell.viewWithTag(20) as! UIImageView
        discName = cell.viewWithTag(21) as! UILabel
        discDate = cell.viewWithTag(22) as! UILabel
        discTitle = cell.viewWithTag(23) as! UILabel
        discImage = cell.viewWithTag(24) as! UIImageView
        discDetails = cell.viewWithTag(25) as! UITextView
        commentAddingButton = cell.viewWithTag(26) as! UIButton!
        favIcon = cell.viewWithTag(27) as! UIImageView
        
        let discussion : PODiscussion = allDiscussionList[indexPath.row]
        
        discName.text = discussion.firstName
        discTitle.text = discussion.titleEn
        discDate.text = discussion.creationDate
        
        discDetailsTemp =  discussion.disDetails
        
        discDetails.text = discDetailsTemp
            
        discPersonImage.configureImage()

        NetworkManager.loadImage(discussion.coverImage!, completionHandler: { (data) in
            self.discImage.image = UIImage(data: data);
        })
        
        print(discussion.userImage)
        print(userImageUrl)
        NetworkManager.loadImage(discussion.userImage!, completionHandler: { (data) in
            self.discPersonImage.image = UIImage(data: data);
        })
        
        if discussion.isfav==1{
            favIcon.image = UIImage(named: "favorite-icon-active")
        } else{
            favIcon.image = UIImage(named: "favorite-icon")
        }
        
        return cell
    }

    
    func decideWhatToDoAfterMyFavoriteDelete(){
        if type == JeeranUtil.DISCUSSION_FAVORITE{
            allDiscussionList.removeAtIndex(currentIndex)
            if allDiscussionList.count==0 {
                notifyNoDataExist()
            } else{
                discussionTableView.reloadData()
            }
        }
    }
    
    func decideWhatToDoAfterMyDiscussionDelete(){
        if type == JeeranUtil.MY_DISCUSSION{
            if allDiscussionList.count==0 {
                notifyNoDataExist()
            } else{
                discussionTableView.reloadData()
            }
        }
    }
    
    @IBAction func displayComments(sender: AnyObject) {
        setCurrentDiscussion(sender)
    }
    
    @IBAction func manipulateFavorites(sender: AnyObject) {
        toggleNetworkAnimator(1)
        setCurrentDiscussion(sender)
        
        favIcon = activeCell.viewWithTag(27) as! UIImageView
        
        if currentDiscussion.isfav==1{ //exist in my favorites
            serviceLayer.deleteFavorite(currentDiscussion.id!)
            currentDiscussion.isfav = 0
            favIcon.image = UIImage(named: "favorite-icon")
            
            decideWhatToDoAfterMyFavoriteDelete()
            
            
            
        } else{ // not exist in my favorites
            serviceLayer.addFavorite(currentDiscussion.id!)
            currentDiscussion.isfav = 1
            favIcon.image = UIImage(named: "favorite-icon-active")
        }
    }
    
    func setCurrentDiscussion(sender : AnyObject){
        let indexPath : NSIndexPath = getIndexPathWithSubview(sender as! UIView)
        currentIndex = indexPath.row
        currentDiscussion = allDiscussionList[indexPath.row]
    }
    
    //get the superview of the view
    func getIndexPathWithSubview(subview: UIView) -> NSIndexPath {
        var view = subview
        while true {
            if view.isKindOfClass(UITableViewCell){
                activeCell = view as! UITableViewCell
                break;
            } else{
                view = view.superview!
            }
        }
        return discussionTableView.indexPathForCell(view as! UITableViewCell)!
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NoDiscussionFavorite"{
            let vc = segue.destinationViewController as! NoFavorites
            vc.navBarTitle = "Discussion"
            vc.modalPresentationStyle = .OverFullScreen
        } else if segue.identifier == "CommentAdding"{
            commentsView = segue.destinationViewController as! Comments
            commentsView.userId = userId
            commentsView.discId = currentDiscussion.id
        } else if segue.identifier == "NoDataFound"{
            let vc = segue.destinationViewController as! NoData
            vc.navBarTitle = "My Discussion"
            vc.modalPresentationStyle = .OverFullScreen
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func postDiscussion(sender: AnyObject) {
        if discussionDetails.text.isEmpty(discussionDetails.text) || discussionDetails.text==placeHolder {
            discussionDetails.changeBorderColor(discussionDetails, empty: true,msg: placeHolder)
        } else{
            toggleNetworkAnimator(1)
            discussionDetails.changeBorderColor(discussionDetails, empty: false,msg:"")
            serviceLayer.addDiscussion("empty",details: discussionDetails.text, neighbordId: neighborId, topicId: selectedTopic.id!,image: discImageToUpload)
        }
    }
    
    func showResponseMessage(msg : String , title : String , state : Int){
        toggleNetworkAnimator(0)
        toggleUploadedImageView(true)
        resetVariables()
        discussionDetails.text = placeHolder
        if state != 5  && state != 2 &&  state != 4 && type != JeeranUtil.DISCUSSION_FAVORITE{
            getDataList()
        
            let alertController = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        }
    }
    
    func resetVariables(){
        discImageToUpload = nil
    }
    
    @IBAction func showTopics(sender: AnyObject) {
        
        let topicsActionSheet : UIAlertController = UIAlertController(title: "Please select a topic", message: "Topic to select", preferredStyle: .ActionSheet)
        
        for topic in topicsList{
            topicsActionSheet.addAction(UIAlertAction(title: topic.topicEn, style: .Default, handler: { (topicActionSheetClosure) in
                self.selectedTopic = topic
                self.topicView.setTitle(self.selectedTopic.topicEn!, forState: .Normal)
            }))
        }
        
        topicsActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        
        self.presentViewController(topicsActionSheet, animated: true, completion: nil)
    }
    
    func reloadDiscussionData(){
        toggleNetworkAnimator(1)
        getDataList()
    }
    
    @IBAction func showMoreOptions(sender: AnyObject) {
        setCurrentDiscussion(sender)
        print(currentDiscussion.id)
        let moreOprionsActionSheet : UIAlertController = UIAlertController(title: "Please select option", message: "", preferredStyle: .ActionSheet)
    
        if currentDiscussion.isOwner == 1 {
            moreOprionsActionSheet.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (topicActionSheetClosure) in
                self.toggleNetworkAnimator(1)
                self.serviceLayer.deleteDiscussion(self.currentDiscussion.id!)
            }))
        }
        
        
        
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Report", style: .Default, handler: { (topicActionSheetClosure) in
            
            self.setCurrentDiscussion(sender)
            
            let reportReasonsView : DiscussionReport = self.storyboard!.instantiateViewControllerWithIdentifier("DiscussionReport") as! DiscussionReport
            reportReasonsView.reportTypeId = 4
            reportReasonsView.reportId = self.currentDiscussion.id
            self.navigationController?.pushViewController(reportReasonsView, animated: true)
        }))
        
        
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        
        self.presentViewController(moreOprionsActionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
        }
        
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = .Camera
        } else{
            imagePicker.sourceType = .PhotoLibrary
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func confirmDiscussionDeleted(){
        self.toggleNetworkAnimator(0)
        allDiscussionList.removeAtIndex(currentIndex)
        if allDiscussionList.count>0 {
            discussionTableView.reloadData()
        } else{
            decideWhatToDoAfterMyDiscussionDelete()
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
            
        let capturedImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        uploadedImageView.image = capturedImage
        toggleUploadedImageView(false)
        closeImagePicker()
        discImageToUpload = capturedImage.getImageData()
//        discImageBytes = capturedImage.getImageArrayOfBytes(capturedImage)
        //print(discImageBytes)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        closeImagePicker()
    }
    
    func closeImagePicker(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func textViewDidBeginEditing(textView: UITextView){
        if discussionDetails.text==placeHolder {
            discussionDetails.text = ""
        }
    }
    func textViewDidEndEditing(textView: UITextView){
        if discussionDetails.text == "" {
            discussionDetails.text = placeHolder
        }
    }
    
    func notifyNoDataExist(){
        
        if type == JeeranUtil.MY_DISCUSSION {
            toggleNetworkAnimator(0)
            self.performSegueWithIdentifier("NoDataFound", sender: self)
        } else if type == JeeranUtil.DISCUSSION_FAVORITE{
            toggleNetworkAnimator(0)
            self.performSegueWithIdentifier("NoDiscussionFavorite", sender: self)
        }
        
    }
    
    /*
    func deleteDiscussion(userId : Int , discussId : Int)->Void{
        Alamofire.request(.POST, url,parameters: ["user_id":userId,"disc_id":discussId], headers: ["Authorization":"Bearer "+token]).responseJSON { (response) in
            
            print(response)
            
            self.discussionTableView.reloadData()
            
        }
    }*/
    
    
    
     /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell: UITableViewCell = super.tableView(tableView, cellForRowAtIndexPath:indexPath)
        return cell.hidden ? 0 : super.tableView(tableView, heightForRowAtIndexPath:indexPath)
    }*/

 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
