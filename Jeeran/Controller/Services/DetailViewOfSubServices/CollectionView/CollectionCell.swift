 //
 //  PaperCell.swift
 //  Papers
 //
 //  Created by Mic Pringle on 09/01/2015.
 //  Copyright (c) 2015 Razeware LLC. All rights reserved.
 //
 
 import UIKit
 
 class CollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var paperImageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rateValue: UILabel!
    
    
    var paper: Paper? {
        didSet {
            if let paper = paper {
                name.text = paper.name
                rateValue.text = String(paper.rate)
                paperImageView.image = paper.imageName
                
            }
        }
    }
    
 }
