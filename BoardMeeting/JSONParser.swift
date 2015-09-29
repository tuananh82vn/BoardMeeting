//
//  JSONParser.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation

struct JSONParser {
    
    static func parseError(story: NSArray) -> [Error] {
        
        var ErrorArray = [Error]()
        
        if let Items = story as Array? {
            
            for var index = 0; index < Items.count; ++index {
                
                if let Item = Items[index] as? NSDictionary {
                    
                    let temp = JSONParser.parseObjectError(Item as NSDictionary)
                    
                    ErrorArray.append(temp)
                }
            }
        }
        
        return ErrorArray
    }
    
    static func parseObjectError(story: NSDictionary) -> Error {
        
        let Object =  Error()
        
        Object.ErrorMessage = story["ErrorMessage"] as? String ?? ""
        
        return Object
    }
    
    static func parseLoginModel(story: NSDictionary) -> LoginModel {
        
        let object =  LoginModel()
        
        object.UserId = story["UserId"] as? Int ?? 0
        
        object.Username = story["Username"] as? String ?? ""
        
        object.FirstName = story["FirstName"] as? String ?? ""
        
        object.Phone = story["Phone"] as? String ?? ""
        
        object.LastName = story["LastName"] as? String ?? ""
        
        object.Email = story["Email"] as? String ?? ""
        
        object.Description = story["Description"] as? String ?? ""
        
              
        return object
    }

}
