
import UIKit

struct LocalStore {

    private static let accessDomainKey = "accessDomainKey"
    
    private static let accessTokenKey = "accessTokenKey"
    
    private static let accessAuditActivityUrlIdKey = "accessAuditActivityUrlIdKey"
    
    
    
    private static let userDefaults = NSUserDefaults.standardUserDefaults()

    
    static func setDomain(token: String) {
        userDefaults.setObject(token, forKey: accessDomainKey)
        userDefaults.synchronize()
    }

    static func setToken(token: String) {
        userDefaults.setObject(token, forKey: accessTokenKey)
        userDefaults.synchronize()
    }
    
    static func setAuditActivityUrlId(AuditActivityUrlId: String) {
        userDefaults.setObject(AuditActivityUrlId, forKey: accessAuditActivityUrlIdKey)
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
    
    private static func deleteAuditActivityUrlId() {
        userDefaults.removeObjectForKey(accessAuditActivityUrlIdKey)
        userDefaults.synchronize()
    }
    
    static func accessDomain() -> String? {
        return userDefaults.stringForKey(accessDomainKey)
    }
    

    static func accessToken() -> String? {
        return userDefaults.stringForKey(accessTokenKey)
    }
    
    static func accessAuditActivityUrlId() -> String? {
        return userDefaults.stringForKey(accessAuditActivityUrlIdKey)
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
