//
//  UINavigationController+Custom.swift
//  Jeeran
//
//  Created by Mac on 6/21/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
extension UINavigationController{
    
     func removeBackBarButtonItem() {
        self.navigationBar.topItem?.title = ""
    }
}
