//
//  IntelliWineTests.swift
//  IntelliWineTests
//
//  Created by Rolland Cédric on 29.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import XCTest
import Foundation
import Alamofire

@testable import IntelliWine

class IntelliWineTests: XCTestCase {
    
    var startScreen: MenuViewController!
    var questionScreen: QuestionViewController!
    var htmlResponse: HTTPURLResponse!
    
    override func setUp() {
        super.setUp()
        startScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MenuViewController.identifier) as! MenuViewController
        questionScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: QuestionViewController.identifier) as! QuestionViewController
        
        htmlResponse = HTTPURLResponse(url: NSURL(string: "dummyURL")! as URL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
    }
    
    override func tearDown() {
        startScreen = nil
        questionScreen = nil
        super.tearDown()
    }
    
    func testGoodQuestionsJSON() {
        let data = getTestData(name: "quiz_data")
        MockRequest.response.data = htmlResponse
        
        do {
            MockRequest.response.json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
        } catch {
            XCTFail()
        }
        
        _ = request("dummyURL").responseJSON { (request, response, JSON, error) -> Void in
            if let questions = JSON as? [[String: Any]]{
                for question in questions {
                    if let question = Question(json: question) {
                        startScreen.questionsArray.append(question)
                    }
                }
                
                XCTAssertEqual(startScreen.questionsArray.count, 13)
            }
        }
    }
    
    func testBadQuestionsJSON() {
        let data = getTestData(name: "bad_quiz_data")
        MockRequest.response.data = htmlResponse
        
        do {
            MockRequest.response.json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
        } catch {
            print(error)
        }
        
        _ = request("dummyURL").responseJSON { (request, response, JSON, error) -> Void in
            if let questions = JSON as? [[String: Any]]{
                for question in questions {
                    XCTAssertNil(Question(json: question))
                }
                
                XCTAssertEqual(startScreen.questionsArray.count, 0)
            }
        }
    }
    
    private func getTestData(name: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: name, ofType: "json")
        return try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    }
    
    private func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil) -> MockRequest {
        
        return MockRequest(request: url as! String)
    }
}
