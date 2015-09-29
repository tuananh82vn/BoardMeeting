//
//  ViewController.swift
//  BoardMeeting
//
//  Created by synotivemac on 29/09/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Spring


class LoginViewController: UIViewController {

    @IBOutlet weak var tft_Password: UITextField!
    @IBOutlet weak var tft_Username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var domain = "http://wsandypham:12345"
        
        LocalStore.setDomain(domain);
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                                        
                                        JSSAlertView().danger(
                                            self,
                                            title: "Success",
                                            text: "Logged in"
                                        )
                                        
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

}

