
import Foundation


class LoginModel : Serializable  {
    var UserId: Int
    var Username: String
    var FirstName: String
    var Phone: String
    var LastName: String
    var Email: String
    var Description : String
    
    override init() {
        UserId = 0
        Username = ""
        FirstName = ""
        Phone = ""
        LastName = ""
        Email = ""
        Description = ""
    }
}

