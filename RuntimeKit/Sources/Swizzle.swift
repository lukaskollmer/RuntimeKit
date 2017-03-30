//
//  Swizzle.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 30/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

enum RuntimeKitError: Error {
    case swizzleMethodNotFound
}

enum MethodType {
    case instance
    case `class`
}

extension NSObject {
    class func swizzle(_ originalSelector: Selector, with swizzledSelector: Selector, methodType: MethodType = .instance) throws {
        
        guard methodType == .instance else {
            fatalError("class methods aren't yet supported")
        }
        
        guard let originalMethod = class_getMethod(self, originalSelector, methodType), let swizzledMethod = class_getMethod(self, swizzledSelector, methodType) else {
            throw RuntimeKitError.swizzleMethodNotFound
        }
        
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    class func replace(_ originalSelector: Selector, withBlock block: Any!, methodType: MethodType = .instance) throws {
        guard methodType == .instance else {
            fatalError("class methods aren't yet supported")
        }
        
        guard let originalMethod = class_getMethod(self, originalSelector, methodType) else {
            throw RuntimeKitError.swizzleMethodNotFound
        }
        
        
        print(String(cString: method_getTypeEncoding(originalMethod)))
        
        guard let swizzledImplementation = imp_implementationWithBlock(block) else {
            fatalError("unable to create IMP from block")
        }
        
        method_setImplementation(originalMethod, swizzledImplementation)
        
        //class_replaceMethod(self, originalSelector, swizzledImplementation, method_getTypeEncoding(originalMethod))
        
        //method_setImplementation(originalMethod, swizzledImplementation)
    }
}


func class_getMethod(_ cls: Swift.AnyClass!, _ name: Selector!, _ methodType: MethodType) -> Method! {
    switch methodType {
    case .instance: return class_getInstanceMethod(cls, name)
    case .class: return class_getClassMethod(cls, name)
    }
}
