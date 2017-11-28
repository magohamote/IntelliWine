//
//  Tag.swift
//  IntelliWine
//
//  Created by Rolland Cédric on 27.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import Foundation

class Tag: NSObject {
    var charac: [String]
    var aroma: [String]
    
    init?(json: [String: Any]?) {
        if let charac = json?["charac"] as? [String],
           let aroma = json?["aroma"] as? [String] {
            self.charac = charac
            self.aroma = aroma
        } else {
            return nil
        }
    }
}
