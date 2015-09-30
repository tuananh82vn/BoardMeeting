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
    
    var localFolder = FolderModel()
    
    
    var folderManager = FolderManager()
    
    var BMAFolderPath : String = ""
    
    var rootPath : String = ""
    
    let RootFolderName = "Board Meeting Files"
    
    var remoteFolderList = [FolderModel]()
    
    var localFolderList = [FolderModel]()
    
    var updateFileList = [FileModel]()
    
    
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
        
        if(isExits){
            
            
        }
        else
        {
            folderManager.CreateFolder(BMAFolderPath)
        }
        
        //Get Local Folder Structure
        self.localFolder = FolderModel()
        
        self.localFolder.FolderName = RootFolderName
        
        self.localFolder = self.getLocalFolder(BMAFolderPath, folder : self.localFolder, parentFolder : self.localFolder.FolderName)
        
        self.SortFolder2(self.localFolder)
        
    }
    
    
    func SortFolder2 (folder: FolderModel) -> Void {
        
        self.localFolderList.append(folder)
        
        if(folder.childFolders.count > 0 ){
            for childfolder in folder.childFolders {
                self.SortFolder2(childfolder)
            }
        }
    }
    


    func getLocalFolder(path : String, folder : FolderModel, parentFolder : String) ->FolderModel {
        
        let (folderNames, errorOpt) = self.folderManager.GetListOfFolder(path)
        
        if(errorOpt == nil)
        {
            if let folderList = folderNames {
                for folderName in folderList {
                    
                    
                    let pathFolder = path.stringByAppendingPathComponent(folderName)
                    
                    if(self.folderManager.IsDirectory(pathFolder))
                    {
                        var childFolder = FolderModel()
                        
                        childFolder.FolderName = parentFolder.stringByAppendingPathComponent(folderName)
                        
                        childFolder = self.getLocalFolder(pathFolder, folder: childFolder, parentFolder : childFolder.FolderName)
                        
                        folder.childFolders.append(childFolder)

                    }
                    else
                    {
                        if(folderName != ".DS_Store") {
                            var childFile = FileModel()
                            childFile.FileName = folderName
                            childFile.FileSize = pathFolder.fileSize
                            childFile.FileDate = pathFolder.fileModificationDate
                            childFile.FilePath = folder.FolderName.stringByAppendingPathComponent(childFile.FileName)
                        
                            folder.childFiles.append(childFile)
                        }
                    }
                }
            }
        }
        
        return folder
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToMain" {
            let main = segue.destinationViewController as! MainViewController
            main.localFolderList = self.localFolderList
        }
    }


}

