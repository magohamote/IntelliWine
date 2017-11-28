//
//  QuestionDataModel.swift
//  IntelliWine
//
//  Created by Rolland Cédric on 27.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import Foundation

protocol QuestionDataModelDelegate: class {
    func didLoadQuizData(questions: [Question])
    func didFailLoadingQuizData(error: Error)
}

class QuestionDataModel {
    
    weak var delegate: QuestionDataModelDelegate?
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "quiz_data", withExtension: "json") else {
            delegate?.didFailLoadingQuizData(error: DataError.noDataError)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let json = json  as? [[String: Any]] {
                setDataWithResponse(response: json)
            } else {
                delegate?.didFailLoadingQuizData(error: DataError.badFormatError)
            }
        } catch {
            delegate?.didFailLoadingQuizData(error: DataError.badFormatError)
        }
    }
    
    private func setDataWithResponse(response: [[String: Any]]) {
        var questionsArray = [Question]()
        
        for data in response {
            if let question = Question(json: data) {
                questionsArray.append(question)
            }
        }
        
        delegate?.didLoadQuizData(questions: questionsArray)
    }
}
