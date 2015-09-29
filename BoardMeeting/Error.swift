//
//  Error.swift
//  DesignerNewsApp
//
//  Created by James Tang on 30/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation

class Error {
    var ErrorMessage : String
    
    init() {
        ErrorMessage = ""
    }
}


class JsonReturnModel {
    
    var Item : String
    var Errors : [Error]
    var IsSuccess : Bool
    
    init() {
        Item = ""
        Errors = [Error]()
        IsSuccess = false
    }
}