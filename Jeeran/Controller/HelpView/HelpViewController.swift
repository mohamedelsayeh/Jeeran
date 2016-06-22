//
//  HelpViewController.swift
//  Jeeran
//
//  Created by Mohammed on 6/12/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, FloatingButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
        (self.navigationController as! FloatingNavigationController).viewDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func floatingButtonDidSelectRowAt(index: Int) {
        switch index {
        case 1:
            self.navigationController?.popToRootViewControllerAnimated(true)
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        default:
            break
        }
    }

}
