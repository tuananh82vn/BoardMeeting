//
//  FolderManager.swift
//  BoardMeeting
//
//  Created by synotivemac on 29/09/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//
import UIKit
import Spring
import Foundation

public class FolderManager {

    func  CheckFolderExits(folderPath: String ) -> Bool
    {
        let fileManager = NSFileManager()
        
        if (fileManager.fileExistsAtPath(folderPath)) {
            
            //println("Folder exist")
            return true
        }
        else
        {
            //println("Folder not exist")
            return false
        }
    }
    
    func CreateFolder(folderPath: String) -> Bool{
        
        let fileManager = NSFileManager()
        
        if fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil, error: nil)
        {
            //println("Folder Created")
            return true
        }
        else
        {
            //println("Could not create the directory")
            return false
        }
    }
    
    func DeleteFolder(folderPath: String) -> Bool{
        let fileManager = NSFileManager()
        
        if (fileManager.removeItemAtPath(folderPath, error: nil)) {
            return true
        }
        else
        {
            return false
        }
    }
    
    func GetListOfFolder(folderPath: String) -> (filenames: [String]?, error: NSError?)
    {
        
        //println("Get list child Folder of " + folderPath.lastPathComponent)
        
        var error: NSError? = nil
        
        let fileManager = NSFileManager()
        
        let content = fileManager.contentsOfDirectoryAtPath(folderPath, error: nil)
        
        if content == nil {
            return (nil, error)
        }
        else {
            let filenames = content as! [String]
            return (filenames, nil)
        }
    }
    
    func CheckFilerExits(file : FileModel , folderName : String) -> Bool {
        
        var result = false;
        
        let LocalFolderList = self.GetListOfFiles(folderName)
        
        for localFile in LocalFolderList {
        
            if(localFile.FileName == file.FileName && localFile.FileSize == file.FileSize && localFile.FileDate == file.FileDate)
            {
                result = true
            }
        }
        
        return result
        
    }
    
    func CheckFilerNotExits(localFile : FileModel, remoteFileFlist : [FileModel]) -> Bool
    {
        var result = true;
        
        for remoteFile in remoteFileFlist {
            
            if(remoteFile.FileName == localFile.FileName && remoteFile.FileSize == localFile.FileSize && remoteFile.FileDate == localFile.FileDate)
            {
                result = false
            }
        }
        
        return result
    }
    
    func DeleteFilesInFolder(filePath: String) -> Bool {
        
        //var error:NSError?
        
        let fileManager = NSFileManager()
        
//        let contents = fileManager.contentsOfDirectoryAtPath(folder, error: &error) as! [String]
//        
//        if let theError = error{
//            println("An error occurred = \(theError)")
//            
//            return false
//        }
//        else
//        {
//
//                let filePath = folder.stringByAppendingPathComponent(deleteFileName)
//                
                if fileManager.removeItemAtPath(filePath, error: nil)
                {
                    
                    //println("Successfully removed item at path \(filePath)")
                    
                    return true
                }
                else
                {
                    //println("Failed to remove item at path \(filePath)")
                    
                    return false
                }
        //}
        
    }
    
    func CreateTestFileFolder(folder: String) -> Void{

            let fileName = "test.txt"
        
            let path = folder.stringByAppendingPathComponent(String(fileName))
        
            let fileContents = "Some text 123"
        
            var error:NSError?
        
            if fileContents.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding,error: &error) == false{
                    if let theError = error{
                        println("Failed to save the file at path \(path)" + " with error = \(theError)")
                    }
            }
        
        
    }
    
    func GetListOfFiles(folder : String) -> [FileModel] {
        
        
        var fileList = [FileModel]()
        
        let filemanager:NSFileManager = NSFileManager()
        
        let files = filemanager.enumeratorAtPath(folder)
         while let file: AnyObject = files?.nextObject() {
            
            //println(file)
            
            let filePath = folder.stringByAppendingPathComponent(file as! String)
            
            var file = FileModel()
            file.FileName = filePath.lastPathComponent
            file.FilePath = filePath
            file.FileSize = filePath.fileSize
            file.FileDate = filePath.fileModificationDate
            
            fileList.append(file)
         }
        
        return fileList
    }
    
    func IsDirectory(path: String) -> Bool {
        
        var isDir = ObjCBool(false)
        
        NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
        
        return isDir.boolValue
    }
    


 
}

extension String {
    var fileExists: Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(self)
    }
    var fileAttributes: [String:AnyObject] {
        return fileExists ? NSFileManager.defaultManager().attributesOfItemAtPath(self, error:nil) as! Dictionary<String, AnyObject> : [:]
    }
    var fileCreationDate:NSDate {
        return fileAttributes["NSFileCreationDate"] as! NSDate
    }
    var fileGroupOwnerAccountName:String{
        return fileAttributes["NSFileGroupOwnerAccountName"] as! String
    }
    var fileType: String {
        return fileAttributes["NSFileType"] as! String
    }
    var fileHFSTypeCode: Int {
        return fileAttributes["NSFileHFSTypeCode"] as! Int
    }
    var fileExtendedAttributes:[String:AnyObject] {
        return fileAttributes["NSFileExtendedAttributes"] as! [String:AnyObject]
    }
    var fileSystemNumber: Int {
        return fileAttributes["NSFileSystemNumber"] as! Int
    }
    var fileOwnerAccountName: String {
        return fileAttributes["NSFileOwnerAccountName"] as! String
    }
    var fileReferenceCount: Int {
        return fileAttributes["NSFileReferenceCount"] as! Int
    }
    var fileModificationDate: NSDate {
        return fileAttributes["NSFileModificationDate"] as! NSDate
    }
    var fileExtensionHidden: Bool {
        return fileAttributes["NSFileExtensionHidden"] as! Bool
    }
    var fileSize: Int {
        return fileAttributes["NSFileSize"] as! Int
    }
    var fileGroupOwnerAccountID: Int {
        return fileAttributes["NSFileGroupOwnerAccountID"] as! Int
    }
    var fileOwnerAccountID: Int {
        return fileAttributes["NSFileOwnerAccountID"] as! Int
    }
    var filePosixPermissions: Int {
        return fileAttributes["NSFilePosixPermissions"] as! Int
    }
    var fileHFSCreatorCode: Int {
        return fileAttributes["NSFileHFSCreatorCode"] as! Int
    }
    var fileSystemFileNumber: Int {
        return fileAttributes["NSFileSystemFileNumber"] as! Int
    }
}