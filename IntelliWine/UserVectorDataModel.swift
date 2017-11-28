//
//  UserVectorDataModel.swift
//  IntelliWine
//
//  Created by Rolland Cédric on 27.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import Foundation

protocol UserVectorDataModelDelegate: class {
    func didLoadUserVectorData(userVector: UserVector)
    func didFailLoadingUserVectorData(error: Error)
}

class UserVectorDataModel {
    
    weak var delegate: UserVectorDataModelDelegate?
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "vector_data", withExtension: "json") else {
            delegate?.didFailLoadingUserVectorData(error: DataError.noDataError)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let json = json  as? [String: Any] {
                setDataWithResponse(response: json)
            } else {
                delegate?.didFailLoadingUserVectorData(error: DataError.badFormatError)
            }
        } catch {
            delegate?.didFailLoadingUserVectorData(error: DataError.badFormatError)
        }
    }
    
    private func setDataWithResponse(response: [String: Any]) {
        if let userVector = UserVector(json: response) {
            delegate?.didLoadUserVectorData(userVector: userVector)
        } else {
            delegate?.didFailLoadingUserVectorData(error: DataError.badFormatError)
        }
    }
}
