//
//  MyProfileViewController.swift
//  Jeeran
//
//  Created by Mohammed on 6/12/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class MyAccountViewController: UITableViewController, ProfileViewDelegate, FloatingButtonDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtUserId: UILabel!
    @IBOutlet weak var txtNeighborhoodAr: UILabel!
    @IBOutlet weak var txtNeighborhoodEn: UILabel!
    @IBOutlet weak var txtDateOfBirth: UILabel!
    @IBOutlet weak var txtFacebookId: UILabel!
    @IBOutlet weak var txtMobile: UILabel!
    @IBOutlet weak var txtDeviceToken: UILabel!
    @IBOutlet weak var txtDeviceType: UILabel!

    var activityIndicator : UIActivityIndicatorView!

    var conn : NetworkManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conn = NetworkManager()
        conn.profileView = self
        conn.getUserProfile()
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .Gray)
        activityIndicator.center = self.view.center;
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

    }

    override func viewDidAppear(animated: Bool) {
        (self.navigationController as! FloatingNavigationController).viewDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func receiveUserData(user: User) {
        lblName.text = user.firstName + " " + user.lastName
        txtEmail.text = user.email
        txtFacebookId.text = user.facebookId
        txtMobile.text = user.mobileNumber
        txtUserId.text = String(user.userId)
        txtDateOfBirth.text = user.dateOfBirth
        txtDeviceType.text = String(user.deviceType)
        txtDeviceToken.text = user.deviceToken
        txtNeighborhoodAr.text = user.neighborhood_ar
        txtNeighborhoodEn.text = user.neighborhood_en
        conn.getDataFromUrl(NSURL(string: user.imageUrl)!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue(), {
                guard let data = data where error == nil else { return }
                self.imgProfile.image = UIImage(data: data)
            })
        }
        self.activityIndicator.removeFromSuperview()
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
