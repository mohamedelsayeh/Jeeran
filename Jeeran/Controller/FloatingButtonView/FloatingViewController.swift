//
//  FloatingViewController.swift
//  Jeeran
//
//  Created by Mohammed on 6/12/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton

class FloatingViewController: UIViewController, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {

    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            return LiquidFloatingCell(icon: UIImage(named: iconName)!)
        }
        cells.append(cellFactory("floatingGroup"))
        cells.append(cellFactory("floatingHome"))
        cells.append(cellFactory("floatingSearch"))
        cells.append(cellFactory("floatingAdd"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        
        self.view.addSubview(bottomRightButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        switch index {
        case 3:
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController((storyboard?.instantiateViewControllerWithIdentifier("AddRealEstateView"))!, animated: true)
            break
        default:
            break
        }
        liquidFloatingActionButton.close()
    }

}
