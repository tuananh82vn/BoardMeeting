//
//  FileModel.swift
//  BoardMeeting
//
//  Created by synotivemac on 29/09/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class FileModel : Serializable  {

    var FilePath: String
    var FileSize: Int
    var FileName: String
    var FileDate: NSDate?
    var FileStatus : String
    var LocalFilePath : String
    
    override init() {
        FilePath = ""
        FileSize = 0
        FileName = ""
        FileDate = NSDate()
        FileStatus = ""
        LocalFilePath = ""
    }
}