//
//  Comments.swift
//  Jeeran
//
//  Created by Mac on 6/7/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class Comments: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    
    @IBOutlet weak var networkWaiting: UIActivityIndicatorView!
    var userName : UILabel!
    var commentDate : UILabel!
    var userImage : UIImageView!
    var comment : UITextView!
    
    var commentObj : POComment!
    var allCommentList : Array<POComment> = []
    var discDetailsTemp : String!
    var currentComment : POComment!
    var discId : Int!
    var userId : Int!
    var serviceLayer : SLComment!
    var placeHolder : String = "Write a comment"
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var commentToPost: UITextView!
    
    func toggleNetworkAnimator(flag : Int){
        if flag==1 { //start animation
            networkWaiting.startAnimating()
        } else{ //stop animating
            networkWaiting.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.removeBackBarButtonItem()
        commentToPost.delegate = self
        serviceLayer = SLComment.getInstance(self)
        loadComments()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadComments(){
        toggleNetworkAnimator(1)
        serviceLayer.getCommentsList(discId)
    }
    
    @IBAction func postComment(sender: AnyObject) {
        if commentToPost.text.isEmpty(commentToPost.text) || commentToPost.text==placeHolder {
            commentToPost.changeBorderColor(commentToPost, empty: true,msg: placeHolder)
        } else{
            toggleNetworkAnimator(1)
            toggleTable(false)
            commentToPost.changeBorderColor(commentToPost, empty: false,msg:"")
            serviceLayer.postComment(discId, comment: commentToPost.text)
        }
    }
    
    
    func setCommentList(allCommentList : Array<POComment>){
        toggleNetworkAnimator(0)
        self.allCommentList = allCommentList
        self.commentsTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allCommentList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        
        userImage = cell.viewWithTag(20) as! UIImageView
        userName = cell.viewWithTag(21) as! UILabel
        commentDate = cell.viewWithTag(22) as! UILabel
        comment = cell.viewWithTag(23) as! UITextView
        
        currentComment = allCommentList[indexPath.row]
        
        userName.text = (currentComment.user?.firstName)!+" "+(currentComment.user?.lastName)!
        commentDate.text = currentComment.creationDate
        comment.text = currentComment.comment
        NetworkManager.loadImage((currentComment.user?.image!)!, completionHandler: { (data) in
            self.userImage.image = UIImage(data: data);
        })
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        currentComment = allCommentList[indexPath.row]
        if currentComment.isOwner == 1 {
            return true
        } else{
            return false
        }
    }
    
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            toggleNetworkAnimator(1)
            serviceLayer.deleteComment(allCommentList[indexPath.row].id!)
            allCommentList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func commitSuccess(state : Int){
        toggleNetworkAnimator(0)
        if state != 3 && state != 2 {
            let alertController = UIAlertController(title: "Success!", message:"Process has been  successfully executed", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        } else if state == 3{
            if allCommentList.count == 0{
                toggleTable(true)
            }
        }
        
        commentToPost.text = placeHolder
    }
    
    func toggleTable(flag : Bool){
        toggleNetworkAnimator(0)
        commentsTableView.hidden = flag //true->hide , false : show
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if commentToPost.text==placeHolder {
            commentToPost.text = ""
        }
    }
    func textViewDidEndEditing(textView: UITextView){
        if commentToPost.text == "" {
            commentToPost.text = placeHolder
        }
    }
}
