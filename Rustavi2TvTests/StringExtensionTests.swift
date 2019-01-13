//
//  StringExtensionTests.swift
//  Rustavi2TvTests
//
//  Created by Zaqro Butskrikidze on 12/6/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import XCTest
import Rustavi2TvShared

class StringExtensionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStringTrim() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let arr:[Character] = [" ", "_", "'"]
        
//        let test22 = "'3'"
//        //print(test22.trimStart(arr).trimEnd(arr))
//        //XCTAssert(test22.trimStart(arr) == "3'")
//        XCTAssert(test22.trimEnd(arr) == "'3")
//        //XCTAssert(test22.trimStart(arr).trimEnd(arr) == "3")
//        return
        
        let test = "   _ ' ioioi ' _   "
        print(test.trimEnd(arr))
        XCTAssert(test.trimEnd(arr) == "   _ ' ioioi")
        print(test.trimStart(arr))
        XCTAssert(test.trimStart(arr) == "ioioi ' _   ")
        print(test.trimStart(arr).trimEnd(arr))
        XCTAssert(test.trimStart(arr).trimEnd(arr) == "ioioi")

        let test2 = "'3'"
        print(test2.trimStart(arr).trimEnd(arr))
        XCTAssert(test2.trimStart(arr) == "3'")
        XCTAssert(test2.trimEnd(arr) == "'3")
        XCTAssert(test2.trimStart(arr).trimEnd(arr) == "3")
        
        let test3 = "3"
        XCTAssert(test3.trimStart(arr) == "3")
        XCTAssert(test3.trimEnd(arr) == "3")
        XCTAssert(test3.trimStart(arr).trimEnd(arr) == "3")
        
        let test4 = "'  '"
        XCTAssert(test4.trimStart(arr).trimEnd(arr) == "")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
