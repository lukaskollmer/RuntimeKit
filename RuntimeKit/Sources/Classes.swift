//
//  Classes.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

/// Struct describing an Objective-C class
public struct ObjCClassDescription {
    /// The classes name
    public let name: String
    
    /// The actual class object (`AnyClass`)
    public let `class`: AnyClass
    
    /// All protocols implemented by the class
    private let protocols: [Protocol]
    
    /// Create a new `ObjCClassDescription` from an `AnyClass` object
    ///
    /// - Parameter `class`: A class
    public init(_ `class`: AnyClass) {
        self.name = String(cString: class_getName(`class`))
        self.class = `class`
        self.protocols = [] // TODO
    }
}


public extension Runtime {
    /// All classes registered with the Objective-C runtime
    public static var allClasses: [ObjCClassDescription] {
        var count: UInt32 = 0
        let classList = objc_copyClassList(&count)
        
        var allClasses = [ObjCClassDescription]()
        
        for i in 0..<count {
            guard let `class` = classList.unsafelyUnwrapped[Int(i)] else { continue }
            allClasses.append(ObjCClassDescription(`class`))
        }
        
        return allClasses
    }
    
    /// Check whether a class with the given name exists
    ///
    /// - Parameter name: A class name
    /// - Returns: `true` if the class exists, otherwise `false`
    public static func classExists(_ name: String) -> Bool {
        return objc_getClass(name.cString(using: .utf8)) != nil
    }
    
    public static func getClass(_ name: String) -> NSObject.Type? {
        return objc_getClass(name.cString(using: .utf8)) as? NSObject.Type
    }
}
