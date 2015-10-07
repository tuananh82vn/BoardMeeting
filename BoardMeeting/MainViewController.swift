//
//  MainViewController.swift
//  BoardMeeting
//
//  Created by synotivemac on 29/09/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Alamofire
import Spring

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIScrollViewDelegate , UISearchBarDelegate , UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var ButtonOpenIn: SpringButton!
    
    @IBOutlet weak var line: UIImageView!
    
    @IBOutlet weak var progressVIew1: UIProgressView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var expandButton: SpringButton!
    
    @IBOutlet weak var tableView1: UITableView!

    var files : [String] = []
    
    var filesTemp : [String] = []
    
    var CellIdentifier: String = "Cell"
    
    var remoteFoler = FolderModel()
    
    var remoteFolderList = [FolderModel]()
    
    var updateFileList = [FileModel]()
    
    var localFolder = FolderModel()
    
    var folderManager = FolderManager()
    
    var localFolderList = [FolderModel]()
    
    var BMAFolderPath : String = ""
    
    let RootFolderName = "Home"
    
    var rootPath : String = NSTemporaryDirectory()

    var path  : String = NSTemporaryDirectory().stringByAppendingPathComponent("Home")

    var numberOfFileDownloaded = 0
    
    var fileManager = NSFileManager()
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    var isExpand : Bool = false
    
    let image_expand = UIImage(named: "expand") as UIImage?
    
    let image_collapse = UIImage(named: "collapse") as UIImage?

    let image_folder = UIImage(named: "folder") as UIImage?
    
    let image_unknown = UIImage(named: "unknown") as UIImage?

    var extensionFile:[String] = ["ppt","mp3","csv","png","pdf","xls","doc","txt","zip","docx","xlsx","pptx"]
    
    var searchActive : Bool = false
    
    var filtered:[String] = []
    
    var selectedFileName = ""
    
    var selectedExtname = ""
    
    var document_controller = UIDocumentInteractionController()
    

    @IBOutlet weak var tableWidthConstraint : NSLayoutConstraint!
   // @IBOutlet weak var fileView: SpringView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //addGradientBackgroundLayer()
        
        self.navigationController?.navigationBarHidden = false
        
        self.progressVIew1.hidden = true
        self.progressLabel.hidden = true
        
        self.webView.hidden = true
        self.expandButton.hidden = true
        self.ButtonOpenIn.hidden = true
        
        //println(path)
        
        //hide back button
        if(path == NSTemporaryDirectory().stringByAppendingPathComponent(RootFolderName))
        {
            addLeftNavItemOnView()
        }
        else
        {
            self.navigationItem.hidesBackButton = false
        }
        
        initData()
        
        document_controller.delegate = self
        
        
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        self.tableView1.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        self.tableView1.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.tableView1.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.tableView1.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

            filtered = self.files.filter({ (text) -> Bool in
                let tmp: NSString = text
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        
            if(filtered.count == 0){
                searchActive = false;
            }
            else {
                searchActive = true;
            }
        
            self.tableView1.reloadData()

    }
    
    @IBAction func ExpandButtonClicked(sender: AnyObject) {
        
        if(!isExpand){
            self.tableWidthConstraint.constant = 0
            isExpand = true
            self.expandButton.setImage(image_collapse, forState: UIControlState.Normal)
            self.searchBar.hidden = true
            self.line.hidden = true
        }
        else
        {
            self.searchBar.hidden = false
            self.line.hidden = false
            self.tableWidthConstraint.constant = 300
            isExpand = false
            self.expandButton.setImage(image_expand, forState: UIControlState.Normal)
        }
    }
    
    func addLeftNavItemOnView ()
    {
        
        // hide default navigation bar button item
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(0, 0, 40, 40)
        buttonBack.setImage(UIImage(named:"logout"), forState: UIControlState.Normal)
        
        buttonBack.addTarget(self, action: "logoutButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
        
    }
    
    func logoutButtonClick(sender:UIButton!)
    {
        
        var alertview = JSSAlertView().show(self, title: "Confirm", text: "Do you want to sign out ?", buttonText: "Yes", cancelButtonText: "No", color: UIColorFromHex(0x2ecc71, alpha: 1))
        alertview.setTextTheme(.Light)
        alertview.addAction(yesSubmitCallBack)
        

    }
    
    func yesSubmitCallBack(){
        
        LocalStore.setToken("")
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        self.navigationController!.pushViewController(loginViewController, animated: true)
    }
    
    func initData(){
        
        var error : NSError?
        
        fileManager = NSFileManager()
        
        self.files = fileManager.contentsOfDirectoryAtPath(path, error: &error) as! [String]

        self.files.sort{ $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        
        self.filtered = self.files
        
        
        
        var index1 = 0
        
        for file in files {
            
            if (file == ".DS_Store")
            {
               files.removeAtIndex(index1)
               filtered.removeAtIndex(index1)
            }
            index1++
        }
        
        self.tableView1.reloadData()
        
        self.title = path.lastPathComponent
    }
    
    
    func reset(){
        
        numberOfFileDownloaded = 0
        
        remoteFoler = FolderModel()
        
        remoteFolderList.removeAll(keepCapacity: false)
        
        updateFileList.removeAll(keepCapacity: false)
        
        localFolder = FolderModel()
        
        localFolderList.removeAll(keepCapacity: false)
    }
    
    func syncFolder(){
        
        WebApiService.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                
        if (internet)
        {
        self.view.showLoading()

        self.reset()
        
        //Get Local Folder Structure
        self.localFolder = FolderModel()
        
        self.localFolder.FolderName = self.RootFolderName
        
        self.BMAFolderPath = self.rootPath.stringByAppendingPathComponent(self.RootFolderName)
        
        self.localFolder = self.getLocalFolder(self.BMAFolderPath, folder : self.localFolder, parentFolder : self.localFolder.FolderName)
        
        self.SortFolder2(self.localFolder)
        
        
        //Get Remote Folder Structure
        WebApiService.getDirectory() { object in
            
            
            if let temp = object {
                
                self.remoteFoler = temp
                
                self.SortFolder1(self.remoteFoler)
                
                self.compareFolder()
                
                if(self.updateFileList.count > 0 ){
                
                    //println("Need download total : \(self.updateFileList.count)")
                    
                    self.downloadFiles()
                }
                else
                {
                    self.progressVIew1.hidden = true
                    self.progressLabel.hidden = true
                    
                    self.view.hideLoading()
                    self.initData()
                }
                

            }
        }
        }
        else
        {
            self.view.hideLoading();
            
            var customIcon = UIImage(named: "no-internet")
            var alertview = JSSAlertView().show(self, title: "Warning", text: "No connections are available ", buttonText: "Try later", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
            alertview.setTextTheme(.Light)
        }
    })
    }
    
    func SortFolder1 (folder: FolderModel) -> Void {
        
        self.remoteFolderList.append(folder)
        
        if(folder.childFolders.count > 0 ){
            for childfolder in folder.childFolders {
                self.SortFolder1(childfolder)
            }
        }
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
    
    func compareFolder() -> Void{
        
        //Check folder in remote and create in Local
        for remoteFolder  in self.remoteFolderList {
            
            let remoteFolderName = remoteFolder.FolderName
            
            var foundFolder = false
            var foundLocalFolder = FolderModel()
            
            
            for localFolder in self.localFolderList
            {
                if (localFolder.FolderName == remoteFolderName){
                    foundFolder = true
                    foundLocalFolder = localFolder
                }
            }
            
            // Folder found in Local
            if (foundFolder){
                //Check Files in this Folder
                for remoteFile in remoteFolder.childFiles {
                    
                    var foundFile = false
                    
                    for localFile in foundLocalFolder.childFiles
                    {
                        if(localFile.FileName == remoteFile.FileName && localFile.FileSize ==  remoteFile.FileSize)
                        {
                            //found File
                            foundFile = true
                        }
                    }
                    
                    //If file not found in Local
                    if(!foundFile)
                    {
                        self.updateFileList.append(remoteFile)
                    }
                }
                
                //Delete file that was deleted in Remote
                for localFile in foundLocalFolder.childFiles
                {
                    var foundFile = false
                    
                    for remoteFile in remoteFolder.childFiles
                    {
                        
//                        println("localFile.FileName : \(localFile.FileName)")
//                        println("localFile.FileSize : \(localFile.FileSize)")
//                        println("localFile.FileDate : \(localFile.FileDate)")
//                        
//                        println("remoteFile.FileName : \(remoteFile.FileName)")
//                        println("remoteFile.FileSize : \(remoteFile.FileSize)")
//                        println("remoteFile.FileDate : \(remoteFile.FileDate)")
                        
                        if(localFile.FileName == remoteFile.FileName && localFile.FileSize ==  remoteFile.FileSize)
                        {
                            //found File
                            foundFile = true
                        }
                    }
                    
                    //If file not found in Local
                    if(!foundFile)
                    {
                        //println("Need to delete :" + localFile.FilePath)
                        self.folderManager.DeleteFilesInFolder(rootPath.stringByAppendingPathComponent(localFile.FilePath))
                    }
                }
                
            }
                // Folder not found in Local
            else
            {
                // Create it
                self.folderManager.CreateFolder(rootPath.stringByAppendingPathComponent(remoteFolderName))
                
                // Copy All Files in this folder
                for remoteFile in remoteFolder.childFiles {
                        self.updateFileList.append(remoteFile)
                }
            }
        }
        
        //delete local folder that was removed or not exits in remote
        for localFolder in self.localFolderList{
            
            let localFolderName = localFolder.FolderName
            
            var foundFolder = false
            
            for remoteFolder in self.remoteFolderList
            {
                if (remoteFolder.FolderName == localFolderName){
                    foundFolder = true
                }
            }
            
            if (foundFolder){
                // Folder found in Local
            }
            else
            {
                // Folder not found in Remote -- Delete it
                self.folderManager.DeleteFolder(rootPath.stringByAppendingPathComponent(localFolderName))
            }
        }
    }
    
    func downloadFiles(){
        
        self.progressVIew1.hidden = false
        self.progressLabel.hidden = false
        
        //Download new files
        for localFile in self.updateFileList{
            getFile(localFile.FilePath+"\\"+localFile.FileName, filePathReturn: rootPath.stringByAppendingPathComponent(localFile.LocalFilePath), fileName : localFile.FileName)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pathForFile(file: String) -> String {
        return self.path.stringByAppendingPathComponent(file)
    }
    
    func fileIsDirectory(file: String) -> Bool {
        
        var isDir = ObjCBool(false)
        var path: String = self.pathForFile(file)
        
        NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
        
        return isDir.boolValue
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filtered.count
        }
        
        return self.files.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

            var cell = self.tableView1.dequeueReusableCellWithIdentifier(CellIdentifier) as! MainTableViewCell
        
            var fileName = ""
        
            if(searchActive)
            {
                fileName = filtered[indexPath.row]
            }
            else
            {
                fileName = self.files[indexPath.row]
            }
        
            
            self.selectedFileName = self.pathForFile(fileName)
            
            var isdir = self.fileIsDirectory(fileName)
            
            //NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isdir)
        
        
            cell.lbl_Title.text = fileName
            
            //cell.lbl_Title.textColor = isdir ? UIColor.blueColor() : UIColor.darkTextColor()
            
            cell.accessoryType = isdir ? UITableViewCellAccessoryType.DisclosureIndicator  : UITableViewCellAccessoryType.None

            if(isdir){
                
                cell.img_icon.contentMode = UIViewContentMode.ScaleAspectFit
                cell.img_icon.image = self.image_folder
            }
            else
            {
        
                var ext = fileName.pathExtension.lowercaseString
                
                cell.img_icon.contentMode = UIViewContentMode.ScaleAspectFit
                
                if contains(self.extensionFile, ext) {
                    
                    let image_icon1 = UIImage(named: ext) as UIImage?
                    
                    cell.img_icon.image = image_icon1
                }
                else
                {
                    cell.img_icon.image = self.image_unknown
                }
            }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var file = ""
        
        if(searchActive)
        {
            file = filtered[indexPath.row]
        }
        else
        {
            file = self.files[indexPath.row]
        }
        
        let SelectedPath = self.pathForFile(file)
        
        self.selectedFileName = self.pathForFile(file)
        
        
        if self.fileIsDirectory(file)
        {
            let mainviewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
            
            mainviewController.path = SelectedPath
            
            self.navigationController!.pushViewController(mainviewController, animated: true)
        }
        else
        {
            //self.view.showLoading()

            self.expandButton.hidden = false
            
            self.ButtonOpenIn.hidden = false
            
            self.webView.hidden = false
            
            var url =  NSURL(fileURLWithPath: SelectedPath)
            
            let request = NSURLRequest(URL: url!)
            
            self.webView.loadRequest(request)
            
            self.webView.delegate = self
            
            self.webView.scrollView.delegate = self
            
            self.title = file
            
            //self.view.hideLoading()
            
        }
    }

    @IBAction func ButtonRefeshClicked(sender: AnyObject) {
        self.syncFolder()
        self.webView.hidden = true
        self.expandButton.hidden = true
    }
    
    func getFile(filePath : String , filePathReturn : String , fileName : String){
        
        //println(filePathReturn)
        
        let baseURL = LocalStore.accessDomain()!
        
        let urlString = baseURL + "/Api/GetFile/?filePath=" + filePath
        

        var urlStr : NSString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        //var remoteUrl : NSURL? = NSURL(string: urlStr as String)
        
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
            (temporaryURL, response) in
            
            
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                
                var localImageURL = NSURL(fileURLWithPath: filePathReturn)
                
                return localImageURL!
            }
            
            return temporaryURL
        }
        
        //self.progressView.hidden = false
        
        Alamofire.download(.GET, urlStr.description, destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                
                //println("bytesRead : ", bytesRead)
                //println("totalBytesRead : ", totalBytesRead)
                //println("totalBytesExpectedToRead : ", totalBytesExpectedToRead)
                
                //This closure is NOT called on the main queue for performance
                //reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)

                    self.progressVIew1.progress = progress
                    self.progressLabel.text =  fileName

                    if totalBytesRead == totalBytesExpectedToRead {
                        
                    }
                }
            }
            .response { response in
                
                self.numberOfFileDownloaded = self.numberOfFileDownloaded + 1
                
                //println("Done")
                
                //Da download xong
                if(self.numberOfFileDownloaded == self.updateFileList.count)
                {
                    self.progressVIew1.hidden = true
                    self.progressLabel.hidden = true
                    
                    //println("Da download xong")
                    
                    self.view.hideLoading()
                    
                    self.initData()
                }
            }
        
    }
    
    @IBAction func event_openin(){
        
        var url_  =  NSURL(fileURLWithPath: self.selectedFileName)
        
        //var url_  = NSBundle.mainBundle().URLForResource(self.selectedFileName, withExtension:nil)
        
        if let item = url_ {
            
            self.selectApp4Openin(item)
        }
    }
    
    
    
    func selectApp4Openin(aUrl : NSURL!) -> Bool{

        
        self.document_controller.URL = aUrl
        
        var bool_ : Bool = false
        
        var rect_inView = self.ButtonOpenIn.frame
        
        bool_ = self.document_controller.presentOptionsMenuFromRect(rect_inView, inView: self.view, animated: true)
        
        return bool_
    }
    

    

}
