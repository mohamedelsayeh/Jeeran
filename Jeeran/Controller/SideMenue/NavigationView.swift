//
//  NavigationView.swift
//  Jeeran
//
//  Created by Mohammed on 6/4/16.
//  Copyright © 2016 Information Technology Institute. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class NavigationView: UITableViewController {
        
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 10
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token")
        if token == nil {
            rows = 9
        }
        return rows
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 1, 2, 3, 4, 5:
            if (NSUserDefaults.standardUserDefaults().objectForKey("token") == nil) {
                let loginView : LoginViewController = storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
                presentViewController(loginView, animated: true, completion: nil)
            } else {
                switch indexPath.row {
                case 1:
                    self.closeLeft()
                    (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController((storyboard?.instantiateViewControllerWithIdentifier("MyAccountView"))!, animated: true)
                    break
                case 2:
                    self.closeLeft()
                    break
                case 3:
                    goToMyRealEstate()
                    self.closeLeft()
                    break
                case 4:
                    goToMyDiscussion()
                    self.closeLeft()
                    break
                case 5:
                    goToMyFavorite()
                    self.closeLeft()
                    break
                default:
                    self.closeLeft()
                    break
                }
            }
            break
        case 6:
            self.closeLeft()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController((storyboard?.instantiateViewControllerWithIdentifier("SettingsView"))!, animated: true)
            break
        case 7:
            self.closeLeft()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController((storyboard?.instantiateViewControllerWithIdentifier("NotificationsView"))!, animated: true)
            break
        case 8:
            self.closeLeft()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController((storyboard?.instantiateViewControllerWithIdentifier("HelpView"))!, animated: true)
            break
        case 9:
            NetworkManager().logout()
            NSUserDefaults.standardUserDefaults().removeObjectForKey("place")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
            let placeSelectView : LoginViewController = storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            self.presentViewController(placeSelectView, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func goToMyRealEstate() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("RealEstate") as! RealState
        vc.type = JeeranUtil.MY_REALESTATE
        (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(vc, animated: true)
    }
    
    func goToMyDiscussion() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Discussion") as! Discussion
        vc.type = JeeranUtil.MY_DISCUSSION
        (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(vc, animated: true)
    }
    
    func goToMyFavorite() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("MyFavoriteTabView") as! UITabBarController
        vc.title = "Favorites"
        ((vc.viewControllers![0] as! UINavigationController).viewControllers[0] as! Discussion).type = JeeranUtil.DISCUSSION_FAVORITE
        ((vc.viewControllers![1] as! UINavigationController).viewControllers[0] as! RealState).type = JeeranUtil.REALESTATE_FAVORITE
        (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(vc, animated: true)
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
