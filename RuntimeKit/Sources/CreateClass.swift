//
//  CreateClass.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation

public extension Runtime {
    public static func createClass(_ name: String, superclass: AnyClass = NSObject.self, protocols: [Protocol] = []) throws  -> NSObject.Type {
        guard !Runtime.classExists(name) else {
            throw RuntimeKitError.classnameAlreadyTaken
        }
        
        guard let newClass = objc_allocateClassPair(superclass, name.cString(using: .utf8)!, 0) else {
            throw RuntimeKitError.unableToCreateClass
        }
        
        objc_registerClassPair(newClass)
        
        protocols.forEach {
            class_addProtocol(newClass, $0)
        }
        
        guard let castedClass = newClass as? NSObject.Type else {
            fatalError("wtf")
        }
        
        return castedClass
    }
}
