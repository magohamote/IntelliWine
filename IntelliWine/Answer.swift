//
//  Answers.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 19/10/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import Foundation

class Answer: NSObject {
    
    var answer: String
    var tags: Tag
    var isExclusive: Bool
    
    init?(json: AnyObject?) {
        if let answer = json?["answer"] as? String,
           let tags = Tag(json: json?["tags"] as? [String: Any]),
           let isExclusive = json?["isExclusive"] as? Bool {
            self.answer = answer
            self.isExclusive = isExclusive
            self.tags = tags
        } else {
            return nil
        }
    }
}
