//
//  NoFavorites.swift
//  Jeeran
//
//  Created by Mac on 6/21/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class NoFavorites: UIViewController {

    var navBarTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navBarTitle
        self.navigationController?.navigationBar.topItem?.title = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popViewControllerAnimated(false)
        self.navigationController?.popViewControllerAnimated(false)
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
