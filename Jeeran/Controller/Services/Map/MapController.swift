//
//  MapController.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/12/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    //  let locationMgr = CLLocationManager()
    var latitude : Double?
    var longitude : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Food and Beverages"
        let location = CLLocation(latitude: latitude!, longitude:longitude!)
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(center, span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "The Colosseum"
        annotation.subtitle = "Suse, Egypt"
        map.addAnnotation(annotation)
        map.mapType = .Hybrid
        map.setRegion(region, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
