//
//  ViewController.swift
//  BoardMeeting
//
//  Created by synotivemac on 29/09/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Spring


class LoginViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var password_img: SpringImageView!
    @IBOutlet weak var email_img: SpringImageView!
    
    @IBOutlet weak var tft_Password: DesignableTextField!
    @IBOutlet weak var tft_Username: DesignableTextField!
    
    var folderManager = FolderManager()
    
    var BMAFolderPath : String = ""
    
    var rootPath : String = NSTemporaryDirectory().stringByAppendingPathComponent("Board Meeting Files")
    
    let RootFolderName = "Board Meeting Files"
    
    
    @IBOutlet weak var heightConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        var domain = "http://wsandypham:12345"
        
        LocalStore.setDomain(domain);
        
        var err: NSErrorPointer = nil
        
        rootPath = NSTemporaryDirectory()

        // Tao thu muc BMA in tmp folder
        BMAFolderPath = rootPath.stringByAppendingPathComponent(RootFolderName)
        
         // Check BMA Folder is exits ???
        let isExits = folderManager.CheckFolderExits(BMAFolderPath)
        
        if(!isExits){
            
            folderManager.CreateFolder(BMAFolderPath)

        }
        
        tft_Password.delegate = self
        tft_Username.delegate = self
        
        //
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        //rotated()

    }
    
    
    //handle when device rotate
    func rotated(){
        
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            self.heightConstraint.constant = 70
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            self.heightConstraint.constant = 250
        }
        
        self.view.layoutIfNeeded()
        
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == tft_Username {
            email_img.image = UIImage(named: "email_selected")
            email_img.animate()
        }
        else {
            email_img.image = UIImage(named: "email_normal")
        }
        
        if textField == tft_Password {
            password_img.image = UIImage(named: "password_selected")
            password_img.animate()
        }
        else {
            password_img.image = UIImage(named: "password_normal")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        email_img.image = UIImage(named: "email_normal")
        password_img.image = UIImage(named: "password_normal")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func ButtonLoginClicked(sender: AnyObject) {
        //Check Internet
        
        self.view.showLoading();
        
        WebApiService.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                
                if (internet)
                {
                    WebApiService.postVerify(LocalStore.accessDomain()!){ objectReturn in
                        
                        
                        if let temp = objectReturn {
                            
                            if(temp.IsSuccess)
                            {
                                WebApiService.loginWithUsername(self.tft_Username.text, password: self.tft_Password.text) { object in
                                    
                                    self.view.hideLoading()
                                    
                                    if let temp = object {
                                        
                                            LocalStore.setToken(temp.Password)
                                        
                                            self.performSegueWithIdentifier("GoToMain", sender: self)
                                        
                                    }
                                    else
                                    {
                                        JSSAlertView().danger(
                                            self,
                                            title: "Error",
                                            text: "Incorrect username or password"
                                        )
                                    }
                                }
                                
                            }
                        }
                        else
                        {
                            var customIcon = UIImage(named: "no-internet")
                            var alertview = JSSAlertView().show(self, title: "Warning", text: "Disconnected", buttonText: "Try later", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
                            alertview.setTextTheme(.Light)
                            
                            self.view.hideLoading();
                        }
                        
                    }
                }
                else
                {
                    var customIcon = UIImage(named: "no-internet")
                    var alertview = JSSAlertView().show(self, title: "Warning", text: "No connections are available ", buttonText: "Try later", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
                    alertview.setTextTheme(.Light)
                }
        })

    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "GoToMain" {
//            let main = segue.destinationViewController as! MainViewController
//            main.localFolderList = self.localFolderList
//        }
//    }


}

