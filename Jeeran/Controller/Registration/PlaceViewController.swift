//
//  SplashViewController.swift
//  Jeeran
//
//  Created by Mohammed on 5/31/16.
//  Copyright © 2016 Information Technology Institute. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ResponseManager {
    
    @IBOutlet weak var placePicker: UIPickerView!
    
//    let places : [String] = ["Al Rehab City", "Altgamoa Elkhames", "Madinaty", "Elshorouk"]
    var neighborhoodList : Array<PONeighborhood> = []
    var place : String!
    var networkManager : NetworkManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgSplash")!)
        placePicker.dataSource = self
        placePicker.delegate = self

        networkManager = NetworkManager()
        networkManager.caller = self
//        networkManager.connectTo("neighborhood/list",header: ["":""],parameters: ["":""],state: 6)
        
//        let gesture = UITapGestureRecognizer(target: self, action: "placeSelected:")
//        placePicker.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return neighborhoodList.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRectMake(20.0, 0, placePicker.frame.width - 20, 37))
        
        if component == 0 {
            label.textAlignment = NSTextAlignment.Left
            label.text = neighborhoodList[row].titleEn
        }
        return label
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        place = neighborhoodList[row].titleEn
        print(place)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        appDelegate.place = self.place
        NSUserDefaults.standardUserDefaults().setObject(place, forKey: "place")
    }
    
    func receiveResponse(response: AnyObject, rState: Int) {
        processNeighborhoodResponse(response)
    }
    
    func processNeighborhoodResponse(resResponse : AnyObject){
        let json = resResponse as! [String: AnyObject]
        let response = json["response"]! as! NSDictionary
        let list:NSArray = response.objectForKey("neighborhoods") as! NSArray
        self.neighborhoodList.removeAll()
        var neighborhoodObj : PONeighborhood!
        for neighborhood in list {
            neighborhoodObj = PONeighborhood()
            neighborhoodObj.id = neighborhood.objectForKey("id") as? Int
            neighborhoodObj.titleEn = neighborhood.objectForKey("title_en") as? String
            neighborhoodObj.titleAr = neighborhood.objectForKey("title_ar") as? String
            self.neighborhoodList.append(neighborhoodObj)
        }
        placePicker.reloadAllComponents()
    }

    
}
