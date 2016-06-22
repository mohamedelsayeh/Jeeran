//
//  RealStateAdding.swift
//  Jeeran
//
//  Created by Mac on 6/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import MapKit

class RealStateAdding: UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var rsTitle: UITextField!
    @IBOutlet weak var rsDesc: UITextField!
    @IBOutlet weak var rsNumOfRooms: UITextField!
    @IBOutlet weak var rsNumOfBathRooms: UITextField!
    @IBOutlet weak var rsArea: UITextField!
    @IBOutlet weak var rsPrice: UITextField!
    @IBOutlet weak var rsLatitude: UITextField!
    @IBOutlet weak var rsLongtitude: UITextField!
    @IBOutlet weak var rsMobile: UITextField!
    @IBOutlet weak var rsEmail: UITextField!
    @IBOutlet weak var rsType: UIButton!
    @IBOutlet weak var rsAmenities: UIButton!
    @IBOutlet weak var neighboarhood: UIButton!
    @IBOutlet weak var rsUnitType: UIButton!
    @IBOutlet weak var realEstateImage: UIImageView!
    @IBOutlet weak var networkWaiting: UIActivityIndicatorView!
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var rsLocation: UITextField!
    
    var vTitle : String = ""
    var vDesc : String = ""
    var vLocation : String = ""
    var vNumOfRooms : String = ""
    var vNumOfBathRooms : String = ""
    var vArea : Double = 0.0
    var vPrice : Int = 0
    var vLatitude : Double = 0.0
    var vLongtitude : Double = 0.0
    var vOwnerName : String = ""
    var vMobile : String = ""
    var vEmail : String = ""
    var vTypeId : Int!
    var vNeighborhoodId : Int!
    var vAmentyId : Int!
    var imageToUpload:NSData! = nil
    var language : Int = 0//En , 1->Ar
    
    var isValidForm : Bool = false
    
    var realEstateObj : PORealState!
    
    var serviceLayer : SLRealState!
    var amenitiesList : Array<POAmenities> = []
    var typesList : Array<POUnitTypes> = []
    var neighborhoodList : Array<PONeighborhood> = []
    var selectedType : Int = 1
    var selectedAmenty : POAmenities!
    var selectedUnitType : POUnitTypes!
    var selectedNeighborhood : PONeighborhood!
    var imagePicker : UIImagePickerController!
    var types : [String] = ["Sale","Rent"]
    
    
    var locationMgr : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.removeBackBarButtonItem()
        
        configureLocationManager()
        serviceLayer = SLRealState.getInstance(self, type: 1)
        toggleNetworkAnimator(1)
        serviceLayer.loadDependencies()
        
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
    }
    
    func configureLocationManager(){
        locationMgr = CLLocationManager()
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.distanceFilter = kCLHeadingFilterNone
        locationMgr.requestAlwaysAuthorization()
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.startUpdatingLocation()
    }
    
    func toggleNetworkAnimator(flag : Int){
        if flag==1 { //start animation
            networkWaiting.startAnimating()
        } else{ //stop animating
            networkWaiting.stopAnimating()
        }
    }
    
    
    @IBAction func showAmenities(sender: AnyObject) {
        let actionSheet : UIAlertController = UIAlertController(title: "Please select an amenty", message: "Amenty to select", preferredStyle: .ActionSheet)
        
        for amenty in amenitiesList{
            actionSheet.addAction(UIAlertAction(title: amenty.titleEn, style: .Default, handler: { (actionSheetClosure) in
                self.selectedAmenty = amenty
                self.rsAmenities.setTitle(self.selectedAmenty.titleEn, forState: .Normal)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func showNeighborhood(sender: AnyObject) {
        let actionSheet : UIAlertController = UIAlertController(title: "Please select a neighborhood", message: "Neighborhood to select", preferredStyle: .ActionSheet)
        
        for neighborhood in neighborhoodList{
            actionSheet.addAction(UIAlertAction(title: neighborhood.titleEn, style: .Default, handler: { (actionSheetClosure) in
                self.selectedNeighborhood = neighborhood
                print(self.selectedNeighborhood.id)
                self.neighboarhood.setTitle(self.selectedNeighborhood.titleEn, forState: .Normal)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func showUnitType(sender: AnyObject) {
        let actionSheet : UIAlertController = UIAlertController(title: "Please select unit type", message: "Unit type to select", preferredStyle: .ActionSheet)
        
        for unitType in typesList{
            actionSheet.addAction(UIAlertAction(title: unitType.titleEn, style: .Default, handler: { (actionSheetClosure) in
                self.selectedUnitType = unitType
                self.rsUnitType.setTitle(self.selectedUnitType.titleEn, forState: .Normal)
                print(self.selectedUnitType.id)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func showTypes(sender: AnyObject) {
        let actionSheet : UIAlertController = UIAlertController(title: "Please select type", message: "Type to select", preferredStyle: .ActionSheet)
        
        for i in 0..<types.count{
            actionSheet.addAction(UIAlertAction(title: types[i], style: .Default, handler: { (actionSheetClosure) in
                self.selectedType = i+1
                print("selected = ",self.selectedType)
                self.rsType.setTitle(self.types[i], forState: .Normal)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 17
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setAmenities(list : Array<POAmenities>){
        amenitiesList = list
        selectedAmenty = amenitiesList[0]
    }
    
    func setTypesList(list : Array<POUnitTypes>){
        typesList = list
        selectedUnitType = typesList[0]
    }
    
    func setNeighborhoodList(list : Array<PONeighborhood>){
        neighborhoodList = list
        selectedNeighborhood = neighborhoodList[0]
        toggleNetworkAnimator(0)
    }
    
    func showLocalMsg(msg : String , title : String){
        let alertController = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) { }
    }
    
    
    func showResponseMessage(msg : String , title : String){
        toggleNetworkAnimator(0)
        let alertController = UIAlertController(title: title, message:msg, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) { }
    }
    
    
    
    @IBAction func uploadImage(sender: AnyObject) {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
        }
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = .Camera
        } else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let capturedImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        realEstateImage.image = capturedImage
        closeImagePicker()
        imageToUpload = capturedImage.getImageData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        closeImagePicker()
    }
    
    func closeImagePicker(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func saveRealEstate(sender: AnyObject) {
        
        if !JeeranUtil.isEmpty(rsTitle) && !rsTitle.text!.isANumber(){
            vTitle = rsTitle.text!
        }
        if !JeeranUtil.isEmpty(rsDesc) && !rsDesc.text!.isANumber(){
            vDesc = rsDesc.text!
        }
        if !JeeranUtil.isEmpty(rsLocation) && !rsLocation.text!.isANumber(){
            vLocation = rsLocation.text!
        }
        if !JeeranUtil.isEmpty(rsNumOfRooms) && rsNumOfRooms.text!.isANumber(){
            vNumOfRooms = rsNumOfRooms.text!
        }
        if !JeeranUtil.isEmpty(rsNumOfBathRooms) && rsNumOfBathRooms.text!.isANumber(){
            vNumOfBathRooms = rsNumOfBathRooms.text!
        }
        if !JeeranUtil.isEmpty(rsArea) && rsArea.text!.isANumber(){
            vArea = Double(rsArea.text!)!
        }
        if !JeeranUtil.isEmpty(rsPrice) && rsPrice.text!.isANumber() {
            vPrice = Int(rsPrice.text!)!
        }
        if !JeeranUtil.isEmpty(rsLatitude) && rsLatitude.text!.isANumber()  {
            vLatitude = Double(rsLatitude.text!)!
        }
        if !JeeranUtil.isEmpty(rsLongtitude) && rsLongtitude.text!.isANumber()  {
            vLongtitude = Double(rsLongtitude.text!)!
        }
        if !JeeranUtil.isEmpty(ownerName) && !ownerName.text!.isANumber() {
            vOwnerName = ownerName.text!
            isValidForm = true
        }
        
        vMobile = rsMobile.text!
        vEmail = rsEmail.text!
        vNeighborhoodId = selectedNeighborhood.id
        vTypeId = selectedUnitType.id
        vAmentyId = selectedAmenty.id
        
        if isValidForm {
            toggleNetworkAnimator(1)
            
            realEstateObj = PORealState()
            
            realEstateObj.type = selectedType
            realEstateObj.rsTitle = vTitle
            realEstateObj.description = vDesc
            realEstateObj.rsLocation = String(vLocation)
            realEstateObj.numOfRooms = Int(vNumOfRooms)
            realEstateObj.numOfBathRooms = Int(vNumOfBathRooms)
            realEstateObj.area = String(vArea)
            realEstateObj.rsPrice = vPrice
            realEstateObj.latitude = vLatitude
            realEstateObj.longitude = vLongtitude
            realEstateObj.language = 0
            realEstateObj.ownerMobile = vMobile
            realEstateObj.ownerEmail = vEmail
            realEstateObj.neighbarhoodId = vNeighborhoodId
            realEstateObj.unitTypeId = vTypeId
            realEstateObj.amenitiesId = vAmentyId
            realEstateObj.ownerName = vOwnerName
            serviceLayer.addRealState(realEstateObj , image: imageToUpload)
        } else{
            showLocalMsg("Invalid fields`s data", title: "Failure")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let locationArray = locations as NSArray
        let location  : CLLocation = locationArray.lastObject as! CLLocation
        rsLatitude.text = String(location.coordinate.latitude)
        rsLongtitude.text = String(location.coordinate.longitude)
    }
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
