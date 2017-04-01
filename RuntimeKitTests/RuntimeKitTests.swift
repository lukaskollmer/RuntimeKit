//
//  RuntimeKitTests.swift
//  RuntimeKitTests
//
//  Created by Lukas Kollmer on 01.04.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import XCTest
import Foundation.NSDate
//@testable import RuntimeKit

class RuntimeKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddMethod() {
        
        let newMethod: @convention(block) (NSDate, Selector) -> NSDate = { (_self, _sel) in
            return dayOfTheDoctor()
        }
        
        try! NSDate.addMethod(Selector(("dayOfTheDoctor")), implementation: newMethod, methodType: .class, returnType: .object, argumentTypes: [.object, .selector])
        
        let date1 = NSDate.perform(Selector(("dayOfTheDoctor"))).takeRetainedValue() as! NSDate
        let date2 = dayOfTheDoctor()
        
        XCTAssertEqual(date1, date2)
    }
    
}
