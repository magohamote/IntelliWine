//
//  IntelliWineUITests.swift
//  IntelliWineUITests
//
//  Created by Rolland Cédric on 28.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import XCTest

class IntelliWineUITests: XCTestCase {
    
    var app:XCUIApplication? = nil
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        app = XCUIApplication()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testAllComponentPresents() {
        guard let app = app else {
            XCTFail()
            return
        }
        
        let startButton = app.buttons["Start"]
        XCTAssertNotNil(startButton)
        startButton.tap()
        
        let nextButton = app.buttons["next question"]
        let previousButton = app.buttons["previous question"]
        
        XCTAssertNotNil(nextButton)
        XCTAssertNotNil(previousButton)
        
        nextButton.tap()
        previousButton.tap()
        
        let answersTable = app.tables["answersTable"]
        
        XCTAssertNotNil(answersTable)
        answersTable/*@START_MENU_TOKEN@*/.staticTexts["Pomme ou poire"]/*[[".cells.staticTexts[\"Pomme ou poire\"]",".staticTexts[\"Pomme ou poire\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    
    func testDisplayResult() {
        guard let app = app else {
            XCTFail()
            return
        }
        
        let startButton = app.buttons["Start"]
        XCTAssertNotNil(startButton)
        startButton.tap()
        
        let nextButton = app.buttons["next question"]
        XCTAssertNotNil(nextButton)
        
        for _ in 0..<12 {
            nextButton.tap()
        }
    
        let recommendButton = app.buttons["recommend"]
        XCTAssertNotNil(recommendButton)
        recommendButton.tap()
        
        let finishButton = app.buttons["finish"]
        XCTAssertTrue(finishButton.waitForExistence(timeout: 10))
        app.buttons["finish"].tap()
    }
}
