//
//  LoginViewController.swift
//  Jeeran
//
//  Created by Mohammed on 5/31/16.
//  Copyright © 2016 Information Technology Institute. All rights reserved.
//

import  UIKit
import FBSDKLoginKit

protocol LoginViewDelegate {
    func receiveLoginResult(isValid: Bool, result : String, token : String)
    func receiveForgotPasswordResult(result : String)
}

class LoginViewController: UIViewController, UITextFieldDelegate, LoginViewDelegate, FacebookLoginDelegate, UIAlertViewDelegate {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    var activityIndicator : UIActivityIndicatorView!
    
    var conn : NetworkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgLogin")!)

        txtEmailAddress.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 2
        btnLogin.layer.borderColor = UIColor(red: 0, green: 121, blue: 180, alpha: 0.5).CGColor
        
        btnForgot.layer.cornerRadius = 5
        btnForgot.layer.borderWidth = 2
        btnForgot.layer.borderColor = UIColor(red: 0, green: 121, blue: 180, alpha: 0.5).CGColor

        btnFacebook.layer.cornerRadius = 5
        btnFacebook.layer.borderWidth = 2
        btnFacebook.layer.borderColor = UIColor(red: 0, green: 121, blue: 180, alpha: 0.5).CGColor
        btnFacebook.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        btnFacebook.imageView?.contentMode = .ScaleAspectFit
        btnCreateAccount.layer.cornerRadius = 5
        btnCreateAccount.layer.borderWidth = 2
        btnCreateAccount.layer.borderColor = UIColor(red: 0, green: 121, blue: 180, alpha: 0.5).CGColor
        btnCreateAccount.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        btnCreateAccount.imageView?.contentMode = .ScaleAspectFit

        conn = NetworkManager()
        conn.loginView = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().objectForKey("token") != nil) {
            storyboard?.instantiateInitialViewController()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doLogin(sender: AnyObject) {
        
        if (txtPassword.text == "" || txtEmailAddress.text == "") {
            lblResult.text = "Missed username or password"
        } else {
            conn.loginWith(txtEmailAddress.text!, password: txtPassword.text!)
            
            activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
            activityIndicator.center = self.view.center;
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {
        let alertView = UIAlertController(title: "Email", message: "Please enter your email address", preferredStyle: .Alert)
        alertView.addTextFieldWithConfigurationHandler { (txtEmail) in
            txtEmail.placeholder = "Email Address"
        }
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action) in
            self.activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
            self.activityIndicator.center = self.view.center;
            self.activityIndicator.startAnimating()
            self.view.addSubview(self.activityIndicator)
            self.conn.forgotPassword(alertView.textFields![0].text!)
        }))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func receiveForgotPasswordResult(result: String) {
        self.activityIndicator.removeFromSuperview()
        lblResult.text = result
    }
    
    func receiveLoginResult(isValid: Bool, result : String, token : String) {
        activityIndicator.removeFromSuperview()
        if isValid {
            NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
            let mainView = storyboard?.instantiateInitialViewController()
            presentViewController(mainView!, animated: true, completion: nil)
        } else {
            lblResult.text = result
        }
    }
    
    func receiveFBLoginResult(isValid: Bool, result: String, token: String) {
        activityIndicator.removeFromSuperview()
        if isValid {
            NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
            let mainView = storyboard?.instantiateInitialViewController()
            presentViewController(mainView!, animated: true, completion: nil)
        } else {
            lblResult.text = result
        }
    }
    
    @IBAction func loginWithFacebook(sender: AnyObject) {
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
                    self.activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
                    self.activityIndicator.center = self.view.center;
                    self.activityIndicator.startAnimating()
                    self.view.addSubview(self.activityIndicator)
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
                    self.txtEmailAddress.text = result.valueForKey("email") as? String
                    self.txtEmailAddress.enabled = false
                    self.txtPassword.enabled = false
                    
                    self.conn.facebookLoginDelegate = self
                    //downloading the image
                    let imageUrl = (result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url"))! as! String
                    self.conn.facebookLoginDelegate = self
                    let name = result.valueForKey("name") as? String
                    let email = result.valueForKey("email") as? String
                    let fbId = result.valueForKey("id") as? String
                    print("\(name)\n\(email)\n\(fbId)\n\(imageUrl)")
                    if email != nil {
                        self.conn.loginWithFacebook(name!, emailAddress: email!, facebookId: fbId!, imageUrl: imageUrl)
                    } else {
                        self.activityIndicator.removeFromSuperview()
                    }
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
