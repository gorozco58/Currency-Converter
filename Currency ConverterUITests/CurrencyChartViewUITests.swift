//
//  CurrencyChartViewUITests.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/14/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import XCTest

class CurrencyChartViewUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChartView() {
        
        let application = XCUIApplication()
        let query = application.otherElements.containing(.navigationBar, identifier:"Currency Converter")
        let chartViews = query.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
        chartViews.element.tap()
        
        XCTAssertEqual(chartViews.count, 1)
    }
    
    func testCurrencyTextField() {
    
        let input = "2"
        let app = XCUIApplication()
        let query = app.otherElements.containing(.navigationBar, identifier:"Currency Converter")
        let textField = query.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        textField.tap()
        
        let initialValue = textField.value as? String
        let deleteKey = app.keyboards.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        app.keyboards.keys[input].tap()
        app.buttons["Done"].tap()
        
        let finalValue = textField.value as? String
        
        XCTAssertNotNil(initialValue)
        XCTAssertNotNil(finalValue)
        XCTAssertNotEqual(initialValue, finalValue)
    }
}
