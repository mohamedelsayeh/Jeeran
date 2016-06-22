//
//  UIImageView+Custom.swift
//  Jeeran
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

extension UIImageView{
    func configureImage(){
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 38
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.clearColor().CGColor
    }
}
