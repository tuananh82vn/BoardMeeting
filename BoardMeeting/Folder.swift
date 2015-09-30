//
//  Folder.swift
//  BoardMeeting
//
//  Created by synotivemac on 29/09/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class FolderModel : Serializable  {
    
    var FolderName: String
    var childFiles : [FileModel]
    var childFolders : [FolderModel]
    var FolderStatus : String
    
    override init() {
        FolderName = ""
        childFiles = [FileModel]()
        childFolders = [FolderModel]()
        FolderStatus = ""
    }
}