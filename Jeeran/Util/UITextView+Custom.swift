//
//  UITextView+Custom.swift
//  Jeeran
//
//  Created by Mac on 6/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
extension UITextView{
    
    func changeBorderColor(field : UITextView , empty : Bool,msg : String){
        var borderColor : UIColor
        field.layer.borderWidth = 1.0
        if empty {
            field.text = msg
            borderColor = UIColor(colorLiteralRed: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        } else{
            field.layer.borderWidth = 0.0
            borderColor = UIColor(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        field.layer.borderColor = borderColor.CGColor
    }
}