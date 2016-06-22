//
//  MainContainerView.swift
//  Jeeran
//
//  Created by Mohammed on 6/4/16.
//  Copyright © 2016 Information Technology Institute. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MainContainerView: SlideMenuController, ProfileViewDelegate {
    
    var mainView : MainNavigationController!
    var leftView : NavigationView!
    var conn : NetworkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conn = NetworkManager()
        // Do any additaaional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        mainView = self.storyboard?.instantiateViewControllerWithIdentifier("MainContentNav") as! MainNavigationController
        self.mainViewController = mainView
        
        leftView = self.storyboard?.instantiateViewControllerWithIdentifier("NavigationView") as! NavigationView
        self.leftViewController = leftView
        
        super.awakeFromNib()
    }
    
    override func viewDidAppear(animated: Bool) {
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token")
        if token != nil {
            let conn = NetworkManager()
            conn.profileView = self
            conn.getUserProfile()
        }
    }
    
    func receiveUserData(user: User) {
        leftView.lblUsername.text = user.firstName + " " + user.lastName
        conn.getDataFromUrl(NSURL(string: user.imageUrl)!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue(), {
                guard let data = data where error == nil else { return }
                self.leftView.imgProfile.image = UIImage(data: data)
            })
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
