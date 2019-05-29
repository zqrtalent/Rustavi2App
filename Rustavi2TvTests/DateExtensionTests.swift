//
//  DateExtensionTests.swift
//  Rustavi2TvTests
//
//  Created by Zaqro Butskrikidze on 11/27/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import XCTest
@testable import Rustavi2TvShared

class DateExtensionTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called uafter the invocation of each test method in the class.
    }
    
    func testParse() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let dt1 = Date.fromTimeString("23:45", formatString: nil)
        XCTAssert(dt1 != nil)
        
        let dt2 = Date.fromTimeString("02:03", formatString: nil)
        XCTAssert(dt2 != nil)
        
        let dt3 = Date.fromTimeString("2018-11-27 23:45", formatString: nil)
        XCTAssert(dt3 != nil)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
