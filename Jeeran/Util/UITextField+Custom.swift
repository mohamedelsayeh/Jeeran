//
//  UITextField+Custom.swift
//  Jeeran
//
//  Created by Mac on 6/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
extension UITextField{
    
    func changeBorderColor(field : UITextField , empty : Bool,msg : String){
        var borderColor : UIColor
        field.layer.borderWidth = 1.0
        if empty {
            print("Empty")
            field.text = msg
            borderColor = UIColor(colorLiteralRed: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        } else{
            field.layer.borderWidth = 0.0
            borderColor = UIColor(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        field.layer.borderColor = borderColor.CGColor
    }
}
