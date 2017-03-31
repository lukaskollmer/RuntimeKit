//
//  Classes.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public struct ObjCClass {
    public let name: String
    public let `class`: AnyClass
    public let protocols: [Protocol]
    
    public init(_ `class`: AnyClass) {
        self.name = String(cString: class_getName(`class`))
        self.class = `class`
        self.protocols = [] // TODO
    }
}


public extension Runtime {
    public static var allClasses: [ObjCClass] {
        var count: UInt32 = 0
        let classList = objc_copyClassList(&count)
        
        var allClasses = [ObjCClass]()
        
        for i in 0..<count {
            guard let `class` = classList.unsafelyUnwrapped[Int(i)] else { continue }
            allClasses.append(ObjCClass(`class`))
        }
        
        return allClasses
    }
    
    public static func classExists(_ name: String) -> Bool {
        return objc_getClass(name.cString(using: .utf8)) != nil
    }
}
