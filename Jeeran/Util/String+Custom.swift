//
//  String+Custom.swift
//  Jeeran
//
//  Created by Mac on 6/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
    
extension String{
    func isEmpty(text : String)->Bool{
        if text.characters.count==0 {
            return true
        }
        return false
    }
    
    func containsWhiteSpace() -> Bool {
        
        // check if there's a range for a whitespace
        let range = self.rangeOfCharacterFromSet(.whitespaceCharacterSet())
        
        // returns false when there's no range for whitespace
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
    func isANumber()->Bool{
        let num = Int(self)
        if num != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func isEmail()->Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
}
    
