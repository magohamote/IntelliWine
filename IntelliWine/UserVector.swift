//
//  UserVector.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 06/11/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import Foundation

class UserVector: NSObject {
    
    var charac: [String: (value: Double, locked: LockState)]
    var aroma: [String: (value: Double, locked: LockState)]
    
    init?(json: [String: Any]?) {
        if let charac = json?["charac"] as? [String],
           let aroma = json?["aroma"] as? [String] {
            
            self.charac = [:]
            self.aroma = [:]
            
            self.charac = charac.map({$0}).reduce([String:(value: Double, locked: LockState)]()) { acc, key in
                var charac = acc
                charac[key] = (value: 0, locked: LockState.unlocked)
                return charac
            }
            
            self.aroma = aroma.map({$0}).reduce([String:(value: Double, locked: LockState)]()) { acc, key in
                var aroma = acc
                aroma[key] = (value: 0, locked: LockState.unlocked)
                return aroma
            }
            
            self.charac["user_foreign_key"] = (value: 1, locked: LockState.locked)
            self.aroma["user_foreign_key"] = (value: 0, locked: LockState.locked)
            
        } else {
            return nil
        }
    }
    
    func lockAll() {
        for (key, _) in charac {
            if charac[key]?.locked == .tmpLocked {
                charac[key]?.locked = .locked
            }
        }
        for (key, _) in aroma {
            if aroma[key]?.locked == .tmpLocked {
                aroma[key]?.locked = .locked
            }
        }
    }
    
    func changeLock(tags: Tag, newLock: (value: Double, locked: LockState)) {
        let characs = tags.charac
        let aromas = tags.aroma
        for key in characs {
            if charac[key]?.locked != .locked {
                charac[key] = newLock
            }
        }
        for key in aromas {
            if charac[key]?.locked != .locked {
                charac[key] = newLock
            }
        }
    }
}

enum LockState {
    case locked
    case unlocked
    case tmpLocked
}
