//
//  UIImage+CustomImage.swift
//  Jeeran
//
//  Created by Mac on 6/14/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

extension UIImage{
    func getImageArrayOfBytes(image : UIImage)->NSMutableArray{
        return getArrayOfBytesFromImage(getImageData())
    }
    
    func getImageData()->NSData{
        
        return UIImageJPEGRepresentation(self, 0.5)!
        //return UIImageJPEGRepresentation(image, 0.0)!
    }
    
    func getArrayOfBytesFromImage(imageData:NSData) -> NSMutableArray
    {
        
        // the number of elements:
        let count = imageData.length / sizeof(UInt8)
        
        // create array of appropriate length:
        var bytes = [UInt8](count: count, repeatedValue: 0)
        
        // copy bytes into array
        imageData.getBytes(&bytes, length:count * sizeof(UInt8))
        
        let byteArray:NSMutableArray = NSMutableArray()
        for i in 0..<count{
            byteArray.addObject(NSNumber(unsignedChar: bytes[i]))
        }
        
        return byteArray
    }
    
    
    
    
}