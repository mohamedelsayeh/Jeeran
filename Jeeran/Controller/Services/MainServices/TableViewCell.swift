//
//  TableViewCell.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/9/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellNotification: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
