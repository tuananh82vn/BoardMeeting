
import UIKit

struct LocalStore {

    private static let accessDomainKey = "accessDomainKey"
    
    private static let accessTokenKey = "accessTokenKey"
    
    private static let accessUsernameKey = "accessUsernameKey"
    
    private static let accessPasswordKey = "accessPasswordKey"
    
    
    private static let userDefaults = NSUserDefaults.standardUserDefaults()

    
    static func setDomain(token: String) {
        userDefaults.setObject(token, forKey: accessDomainKey)
        userDefaults.synchronize()
    }

    static func setToken(token: String) {
        userDefaults.setObject(token, forKey: accessTokenKey)
        userDefaults.synchronize()
    }
    
    static func setUsername(Username: String) {
        userDefaults.setObject(Username, forKey: accessUsernameKey)
        userDefaults.synchronize()
    }
    
    static func setPassword(Password: String) {
        userDefaults.setObject(Password, forKey: accessPasswordKey)
        userDefaults.synchronize()
    }

    
    private static func deleteDomain() {
        userDefaults.removeObjectForKey(accessDomainKey)
        userDefaults.synchronize()
    }
    
    private static func deleteToken() {
        userDefaults.removeObjectForKey(accessTokenKey)
        userDefaults.synchronize()
    }
    
    private static func deleteUsername() {
        userDefaults.removeObjectForKey(accessUsernameKey)
        userDefaults.synchronize()
    }
    
    private static func deletePassword() {
        userDefaults.removeObjectForKey(accessPasswordKey)
        userDefaults.synchronize()
    }
    
    static func accessDomain() -> String? {
        return userDefaults.stringForKey(accessDomainKey)
    }
    

    static func accessToken() -> String? {
        return userDefaults.stringForKey(accessTokenKey)
    }
    
    static func accessUsername() -> String? {
        return userDefaults.stringForKey(accessUsernameKey)
    }
    
    static func accessPassword() -> String? {
        return userDefaults.stringForKey(accessPasswordKey)
    }


    // MARK: Helper

    static private func arrayForKey(key: String, containsId id: Int) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        return contains(elements, id)
    }

    static private func appendId(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if !contains(elements, id) {
            userDefaults.setObject(elements + [id], forKey: key)
            userDefaults.synchronize()
        }
    }

    static private func removeId(id: Int, forKey key: String) {
        var elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if let index = find(elements, id) {
            elements.removeAtIndex(index)
            userDefaults.setObject(elements, forKey: key)
            userDefaults.synchronize()
        }
    }
}
