//
//  Discussiontest.swift
//  Jeeran
//
//  Created by Mac on 6/5/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Discussiontest: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var listData: UIButton!
    
    
    @IBAction func getDiscussionList(sender: AnyObject) {

        
        
        Alamofire.request(.GET, "", parameters: ["aa":"aa"]).response
        
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
