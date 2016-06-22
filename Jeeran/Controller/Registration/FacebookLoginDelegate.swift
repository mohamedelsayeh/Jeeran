//
//  FacebookLoginDelegate.swift
//  Jeeran
//
//  Created by Mohammed on 6/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation

protocol FacebookLoginDelegate {
    func receiveFBLoginResult(isValid: Bool, result : String, token: String)
}