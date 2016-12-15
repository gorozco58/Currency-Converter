//
//  CurrencyModelsTestCase.swift
//  Currency Converter
//
//  Created by Giovanny Orozco on 12/14/16.
//  Copyright © 2016 Giovanny Orozco. All rights reserved.
//

import XCTest
import Alamofire
@testable import Currency_Converter

class MainViewControllerTestCase: XCTestCase {

    let timeout: TimeInterval = 30.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainViewControllerSuccess() {
    
        // Given
        let base = Currency(dictionary: (key: "USD", value: 1))
        let mainVC = MockMainViewController(base: base)
        let expectation = self.expectation(description: "request should succeed")
        var result: Result<[Currency]>? = nil
        
        // When
        mainVC.loadCurrencies()
        mainVC.onCompleLoadData = { data in
            result = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.isSuccess ?? false)
        XCTAssertNotNil(result?.value)
        XCTAssertNil(result?.error)
    }
    
    func testMainViewControllerFail() {
        
        // Given
        let base = Currency(dictionary: (key: "INVALID-BASE", value: 1))
        let mainVC = MockMainViewController(base: base)
        let expectation = self.expectation(description: "request should succeed")
        var result: Result<[Currency]>? = nil
        
        // When
        mainVC.loadCurrencies()
        mainVC.onCompleLoadData = { data in
            result = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        let error = result?.error as? CommonError
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.isFailure ?? false)
        XCTAssertNil(result?.value)
        XCTAssertNotNil(error)
        XCTAssertNotNil(error?.localizedDescription)
    }
}

class MockMainViewController : MainViewController {

    var onCompleLoadData: ((Result<[Currency]>) -> Void)?
    
    override func reloadData() {
        
        if let onCompleLoadData = onCompleLoadData {
            onCompleLoadData(.success(currencies))
        }
    }
    
    override func show(error: Error) {
        
        super.show(error: error)
        
        if let onCompleLoadData = onCompleLoadData {
            onCompleLoadData(.failure(error))
        }
    }
}
