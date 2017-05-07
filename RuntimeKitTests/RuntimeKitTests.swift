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
    
    func testReplaceMethod() {
        let method: @convention(block) (NSString, Selector, String) -> Bool = { (_self, _sel, string) in
            return false
        }
        
        try! NSString.replace(#selector(NSString.contains(_:)), withBlock: method)
        
        let string = NSString(string: "i am the doctor")
        let contains = string.contains("doctor")
        
        XCTAssertEqual(contains, false)
    }
    
    func testSetSingleAssociatedObject() {
        class Person: NSObject {}
        
        let nameKey = AssociatedObjectKey<String>("name")
        
        let me = Person()
        me.setAssociatedObject("Lukas", forKey: nameKey)
        
        let name = me.getAssociatedObject(forKey: nameKey)!
        
        XCTAssertEqual(name, "Lukas")
    }
    
    func testSetClassAsAssociatedObject() {
        class Person: NSObject {}
        class Address: NSObject {}
        
        let nameKey        = AssociatedObjectKey<String>("name")
        let addressKey     = AssociatedObjectKey<Address>("address")
        let streetKey      = AssociatedObjectKey<String>("street")
        let houseNumberKey = AssociatedObjectKey<Int>("houseNumber")
        let cityKey        = AssociatedObjectKey<String>("city")
        
        
        let address = Address()
        address.setAssociatedObject("Random Street", forKey: streetKey)
        address.setAssociatedObject(5, forKey: houseNumberKey)
        address.setAssociatedObject("Munich", forKey: cityKey)
        
        let me = Person()
        me.setAssociatedObject("Lukas", forKey: nameKey)
        me.setAssociatedObject(address, forKey: addressKey)
        
        
        let myAddress = me.getAssociatedObject(forKey: addressKey)!
        
        XCTAssertEqual(myAddress, address)
        
        XCTAssertEqual(myAddress.getAssociatedObject(forKey: streetKey)!, "Random Street")
        XCTAssertEqual(myAddress.getAssociatedObject(forKey: houseNumberKey)!, 5)
        XCTAssertEqual(myAddress.getAssociatedObject(forKey: cityKey)!, "Munich")
    }
    
    func testValueTypeAssociatedObject() {
        class Person: NSObject {}
        struct Name {
            let first: String
            let last: String
        }
        
        let nameKey = AssociatedObjectKey<Name>("name")
        let ageKey = AssociatedObjectKey<Int>("age")
        
        let me = Person()
        let name = Name(first: "Lukas", last: "Kollmer")
        me.setAssociatedObject(name, forKey: nameKey)
        me.setAssociatedObject(18, forKey: ageKey)
        
        
        let myName = me.getAssociatedObject(forKey: nameKey)!
        let myAge = me.getAssociatedObject(forKey: ageKey)!
        
        XCTAssertEqual(myName.first, name.first)
        XCTAssertEqual(myName.last, name.last)
        XCTAssertEqual(myAge, 18)
    }
    
    
    func testCreateNewClass() {
        let OurCustomClass = try! Runtime.createClass("OurCustomClass")
        
        XCTAssert(OurCustomClass == Runtime.getClass("OurCustomClass")!)
        
        let method: @convention(block) (NSObject, Selector, String) -> String = { (_self, _sel, name) in
            return "Hello, \(name)!"
        }
        
        try! OurCustomClass.addMethod(Selector(("greet:")), implementation: method, methodType: .class, returnType: .object, argumentTypes: [.object, .selector, .object])
        
        if let result = OurCustomClass.perform(Selector(("greet:")), with: "Lukas").takeUnretainedValue() as? String {
            XCTAssertEqual(result, "Hello, Lukas!")
        } else {
            XCTAssert(false, "Didn't return expected type")
        }
    }
    
    func testCustomPerformSelector() {
        let formatBlock: @convention(block) (NSDate, Selector, String) -> String = { (_self, _sel, format) in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: _self as Date)
        }
        
        try! NSDate.addMethod(Selector(("customFormat:")), implementation: formatBlock, methodType: .instance, returnType: .object, argumentTypes: [.object, .selector, .object])
        
        let customFormatSel = ObjCMethodCallRequest<String>("customFormat:")
        
        let date = dayOfTheDoctor()
        
        let formattedString: String = try! date.perform(customFormatSel, "EEEE MMM d, yyyy").takeUnretainedValue()
        
        XCTAssertEqual(formattedString, "Saturday Nov 23, 2013")
    }
    
}
