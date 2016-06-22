//
//  SettingsViewController.swift
//  Jeeran
//
//  Created by Mohammed on 6/12/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, FloatingButtonDelegate {

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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
