//
//  SimilarityScoreDataModel.swift
//  IntelliWine
//
//  Created by Rolland Cédric on 27.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import Foundation
import Alamofire

protocol SimilarityScoreDataModelDelegate: class {
    func didComputeSimilaritySuccesfully(answer: Double)
    func didFailComputingSimilarity(error: Error)
}

class SimilarityScoreDataModel {
    
    weak var delegate: SimilarityScoreDataModelDelegate?
    
    func transformCharac(userVector: UserVector, key: String, maxCharac: Int) {
        
        var characTransformed:[Double] = []
        var startIndex = -1
        var stopIndex = -1
        
        for i in 1...maxCharac {
            if let value = userVector.charac["\(key)\(i)"]?.value {
                characTransformed.append(value)
            }
        }
        
        if let firstElem = characTransformed.first(where: {$0 == 1}), let index = characTransformed.index(of: firstElem) {
            startIndex = index
        }
        
        if let lastElem = characTransformed.reversed().first(where: {$0 == 1}), let index = characTransformed.index(of: lastElem) {
            stopIndex = characTransformed.count - 1 - index
        }
        
        if startIndex == -1 && stopIndex != startIndex {
            delegate?.didFailComputingSimilarity(error: DataError.badFormatError)
        }
        
        for i in startIndex...stopIndex {
            userVector.charac["\(key)\(i)"]?.value = 1
        }
    }
    
    func transformUserVector(_ userVector: UserVector) -> [String: [String: Double]]{
        
        transformCharac(userVector: userVector, key: "sweetness", maxCharac: 6)
        transformCharac(userVector: userVector, key: "acidity", maxCharac: 5)
        transformCharac(userVector: userVector, key: "tannin", maxCharac: 5)
        transformCharac(userVector: userVector, key: "alcohol", maxCharac: 5)
        transformCharac(userVector: userVector, key: "body", maxCharac: 5)
        transformCharac(userVector: userVector, key: "flavour_intensity", maxCharac: 5)
        
        var simpleVector = [String: [String: Double]]()
        var characs = [String: Double]()
        var aroma = [String: Double]()
        
        for(_, elem) in userVector.charac.enumerated() {
            characs[elem.key] = elem.value.value
        }
        
        for(_, elem) in userVector.aroma.enumerated() {
            aroma[elem.key] = elem.value.value
        }
        
        simpleVector["charac"] = characs
        simpleVector["aroma"] = aroma
        return simpleVector
    }
    
    func computeSimilarity(userVector: UserVector) throws {
        
        let values = transformUserVector(userVector)
        
        let user = "admin"
        let password = "password123"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        var request = try URLRequest(url: URL(string: "https://intelliwine.herokuapp.com/compute_similarity/")!, method: HTTPMethod(rawValue: "POST")!, headers: ["Authorization": "Basic \(base64Credentials)"])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: values, options: [])
        
        Alamofire.request(request).response { response in
            guard let data = response.data else {
                if let error = response.error {
                    print("Error while fetching data: \(error)")
                    self.delegate?.didFailComputingSimilarity(error: error)
                }
                return
            }
            self.setDataWithResponse(response: data)
        }
    }
    
    private func setDataWithResponse(response: Data) {
        let jsonData: Data = response
        do {
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? Double {
                delegate?.didComputeSimilaritySuccesfully(answer: jsonDict)
            }
        } catch {
            delegate?.didFailComputingSimilarity(error: DataError.badFormatError)
        }
    }
}

