//
//  RegisterViewController.swift
//  Jeeran
//
//  Created by Mohammed on 6/1/16.
//  Copyright © 2016 Information Technology Institute. All rights reserved.
//

import UIKit
import FBSDKLoginKit

protocol RegisterViewDelegate {
    func receiveRegisterationResult(isValid : Bool, result : String)
}

class RegisterViewController: UIViewController, RegisterViewDelegate, FacebookLoginDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var conn : NetworkManager!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    
    var fbReg : FBSDKLoginButton!
    var imagePicker : UIImagePickerController!
    
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgRegister")!)
        
        txtName.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        txtEmailAddress.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        txtRePassword.attributedPlaceholder = NSAttributedString(string: "Retype Password", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        btnRegister.layer.cornerRadius = 5
        btnRegister.layer.borderWidth = 2
        btnRegister.layer.borderColor = UIColor(red: 0, green: 121, blue: 180, alpha: 0.5).CGColor
        
        btnFacebook.layer.cornerRadius = 5
        btnFacebook.layer.borderWidth = 2
        btnFacebook.layer.borderColor = UIColor(red: 0, green: 121, blue: 180, alpha: 0.5).CGColor
        btnFacebook.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        btnFacebook.imageView?.contentMode = .ScaleAspectFit
        // Do any additional setup after loading the view.
        
        conn = NetworkManager()
        conn.registerationView = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func choosePicture(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imgProfile.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doRegister(sender: AnyObject) {
        if (txtPassword.text == "" || txtEmailAddress.text == "" || txtName.text == "" || txtRePassword == "") {
            lblResult.text = "All fields are required"
        } else if txtPassword.text != txtRePassword.text {
            lblResult.text = "Mismatch Password"
        } else if txtName.text?.componentsSeparatedByString(" ").count != 2 {
            lblResult.text = "Invalid username, e.g. John Snow"
        } else {
            conn.registerUser(txtName.text!, email: txtEmailAddress.text!, password: txtPassword.text!, image: imgProfile.image!)
            
            activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
            activityIndicator.center = self.view.center;
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    
    func receiveRegisterationResult(isValid: Bool, result : String) {
        activityIndicator.removeFromSuperview()
        lblResult.text = result
    }
    
    func receiveFBLoginResult(isValid: Bool, result : String, token: String) {
        activityIndicator.removeFromSuperview()
        if isValid {
            NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
            storyboard?.instantiateInitialViewController()
        } else {
            lblResult.text = result
        }
    }
    @IBAction func registerWithFacebook(sender: AnyObject) {
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.center = self.view.center;
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        let permissions = ["public_profile","email","user_friends"]
        let loginMngr : FBSDKLoginManager = FBSDKLoginManager()
        loginMngr.logInWithReadPermissions(permissions, fromViewController: self) { (result, error) in
            if ((error) != nil) {
                let alert = UIAlertController(title: "Facebook Login Failed", message: "Sorry Champ! We Couldn't Login with your Facebook. Try Again Later!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                print("\(error)")
            } else if (result.isCancelled) {
                print("Cancelled")
            } else {
                if (result.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    self.txtName.text = result.valueForKey("name") as? String
                    self.txtEmailAddress.text = result.valueForKey("email") as? String
                    
                    //download the profile picture and send the request to the service
                    let imageUrl = (result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url")! as! String)
                    self.getDataFromUrl(NSURL(string: imageUrl)!) { (data, response, error)  in
                        dispatch_async(dispatch_get_main_queue(), { 
                            guard let data = data where error == nil else { return }
                            self.imgProfile.image = UIImage(data: data)
                            self.conn.facebookLoginDelegate = self
                            self.conn.loginWithFacebook((result.valueForKey("name") as? String)!, emailAddress: (result.valueForKey("email") as? String)!, facebookId: (result.valueForKey("id") as? String)!, imageUrl: imageUrl)
                        })
                    }
                    
                    self.txtEmailAddress.enabled = false
                    self.txtPassword.enabled = false
                    self.txtRePassword.enabled = false
                    self.txtName.enabled = false
                    
                } else {
                    let alert = UIAlertController(title: "Facebook Login Failed", message: "Sorry Champ! We Couldn't Login with your Facebook. Try Again Later!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("Error: \(error)")
                }
            })
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

