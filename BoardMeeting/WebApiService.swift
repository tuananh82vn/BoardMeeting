
import Alamofire

struct WebApiService {

    
    private enum ResourcePath: Printable {
        case Login
        case Verify
        case GetDirectory
        case GetFile
        
        
        var description: String {
            switch self {
                case .Login: return "/Api/Login"
                case .Verify: return "/Api/Verify"
                case .GetDirectory: return "/Api/GetDirectory"
                case .GetFile: return "/Api/GetFile/?filePath="

            }
        }
    }
    
    static func checkInternet(flag:Bool, completionHandler:(internet:Bool) -> Void)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url = NSURL(string: "http://www.google.com/")
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue(), completionHandler:
            {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                let rsp = response as! NSHTTPURLResponse?
                
                completionHandler(internet:rsp?.statusCode == 200)
        })
    }

    static func loginWithUsername(Username: String, password: String, response: (object: LoginModel?) -> ()) {
        
        let baseURL = LocalStore.accessDomain()!
        
        let urlString = baseURL + ResourcePath.Login.description

        
        let parameters = [
            "Item": [
                "Username": Username,
                "Password": password
            ]
        ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json == nil ){
                response(object: nil)
            }
            else
            {
            
                let jsonObject = JSON(json!)
                
                //println(jsonObject)

                let IsSuccess = jsonObject["IsSuccess"].bool
            
                if(IsSuccess?.boolValue == true)
                {
                    if let Item = jsonObject["Item"].dictionaryObject {
                        
                        let Return = JSONParser.parseLoginModel(Item as NSDictionary)
                        
                        response (object : Return)
                    }
                }
                else
                {
                    response(object: nil)
                }
            }
        }
    }
    
    static func postVerify(domain: String,  response : (objectReturn : JsonReturnModel?) -> ()) {
        
        let urlString = domain + ResourcePath.Verify.description
        

        var JsonReturn = JsonReturnModel()
        
        Alamofire.request(.POST, urlString, parameters: nil , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
            
        }
        
    }
    
    static func getDirectory(response: (object: FolderModel?) -> ()) {
        
        let baseURL = LocalStore.accessDomain()!
        
        let urlString = baseURL + ResourcePath.GetDirectory.description
        
        
        let parameters = [
                "Password": LocalStore.accessToken()!
        ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json == nil ){
                response(object: nil)
            }
            else
            {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)
                
                let IsSuccess = jsonObject["IsSuccess"].bool
                
                if(IsSuccess?.boolValue == true)
                {
                    if let Item = jsonObject["Item"].dictionaryObject {
                        
                        let Return = JSONParser.parseDirectory(Item as NSDictionary)

                        response (object : Return)
                    }
                }
                else
                {
                    response(object: nil)
                }
            }
        }
    }
    
    static func getFile(filePath : String , filePathReturn : String){
        
        //println(filePathReturn)
        
        let baseURL = LocalStore.accessDomain()!
        
        let urlString = baseURL + ResourcePath.GetFile.description + filePath
        
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

        Alamofire.download(.GET, urlStr.description, destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                
                
                //println("bytesRead : ", bytesRead)
                //println("totalBytesRead : ", totalBytesRead)
                //println("totalBytesExpectedToRead : ", totalBytesExpectedToRead)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    //print("Total bytes read on main queue: \(totalBytesRead)")
                }
            }

    }
}
