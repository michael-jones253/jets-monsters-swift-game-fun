//
//  TestFrameWorkTests.swift
//  TestFrameWorkTests
//
//  Created by Michael Jones on 16/03/2015.
//  Copyright (c) 2015 Michael Jones. All rights reserved.
//

import Cocoa
import XCTest
import TestFrameWork

class TestFrameWorkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        let myTest = MyTest()
        
        myTest.GoodBye()
        
        
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
