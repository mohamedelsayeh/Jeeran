//
//  Paper.swift
//  Wallpapers
//
//  Created by Mic Pringle on 07/01/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class Paper {
    
    var caption: String
    var imageName: String?
    var section: String
    var index: Int
    var rate: Int
    var name: String
    
    init(caption: String, imageName:String, section: String, index: Int, rate : Int, name: String) {
        self.caption = caption
        self.imageName = imageName
        self.section = section
        self.index = index
        self.rate = rate
        self.name = name
    }
    
//    init(caption: String, section: String, index: Int, rate : Int, name: String) {
//        self.caption = caption
//        self.section = section
//        self.index = index
//        self.rate = rate
//        self.name = name
//        
//    }
    convenience init(copying paper: Paper) {
        self.init(caption: paper.caption, imageName: paper.imageName!, section: paper.section, index: paper.index ,rate: paper.rate,name: paper.name)
    }
    
}



