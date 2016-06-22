//
//  Reviews.swift
//  Jeeran
//
//  Created by Mac on 5/23/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RateView


class Reviews: UITableViewController {
    
    var rateView : RateView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 0.0, green: 121/255, blue: 180/255, alpha: 1.0)  ]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        self.navigationController?.navigationBar.titleTextAttributes.
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell", forIndexPath: indexPath)
        let ratingBarView = cell.viewWithTag(3)
        
        
        rateView = RateView(rating: 2.0)
        rateView?.starSize = 13
        rateView?.canRate = true
        
        
        ratingBarView!.addSubview(rateView!)
        
        let reviewImage : UIImageView! = cell.viewWithTag(1) as! UIImageView
        /*let reviewPerosnName : UILabel! = cell.viewWithTag(2) as! UILabel
        let reviewDate : UILabel! = cell.viewWithTag(4) as! UILabel
        let reviewSpec : UILabel! = cell.viewWithTag(5) as! UILabel
        let reviewDesc : UITextView! = cell.viewWithTag(6) as! UITextView*/
        
        reviewImage.layer.borderWidth = 1.0
        reviewImage.layer.cornerRadius = 37
        reviewImage.clipsToBounds = true
        reviewImage.layer.borderColor = UIColor.clearColor().CGColor
        reviewImage.image = UIImage(named: "img.jpg")
        
        return cell
    }
 

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
