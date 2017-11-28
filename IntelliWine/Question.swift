//
//  Questions.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 19/10/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import Foundation

class Question: NSObject {
    
    class var questionsArrayKey: String {
        return "KQUESTIONS_COUNT"
    }
    
    var question: String
    var answers: [Answer]
    
    init?(json: [String : Any]?) {
        if let question = json?["question"] as? String,
           let answers = json?["answers"] as? [AnyObject] {
            self.question = question
            self.answers = []
            for object in answers {
                if let answer = Answer(json: object) {
                    self.answers.append(answer)
                }
            }
        } else {
            return nil
        }
    }
}
