//
//  Swizzle.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 30/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public enum MethodType {
    case instance
    case `class`
}

public extension NSObject {
    /// Swizzle a method
    ///
    /// - Parameters:
    ///   - originalSelector: The method's original selector
    ///   - swizzledSelector: The new selector to swizzle with
    ///   - methodType: `MethodType` case determining whether you want to swizzle an instance method (`.instance`) or a class method (`.class`)
    /// - Throws: `RuntimeKitError.swizzleMethodNotFound` if the selectors cannot be found on `self`
    public static func swizzle(_ originalSelector: Selector, with swizzledSelector: Selector, methodType: MethodType = .instance) throws {
        
        let cls: AnyClass = methodType == .instance ? self : object_getClass(self)
        
        guard let originalMethod = class_getMethod(cls, originalSelector, methodType), let swizzledMethod = class_getMethod(cls, swizzledSelector, methodType) else {
            throw RuntimeKitError.swizzleMethodNotFound
        }
        
        
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    /// Replace a method's implementation with a block
    ///
    /// - Parameters:
    ///   - originalSelector: The selector of the method you want to replace
    ///   - block: The block to be called instead of the method's implementation
    ///   - methodType: `MethodType` case determining whether you want to replace an instance method (`.instance`) or a class method (`.class`)
    /// - Throws: `RuntimeKitError.swizzleMethodNotFound` if the method cannot be found or `RuntimeKitError.unableToCreateMethodImplmentationFromBlock` if the block cannot be turned into a method implementation
    public static func replace(_ originalSelector: Selector, withBlock block: Any!, methodType: MethodType = .instance) throws {
        
        let cls: AnyClass = methodType == .instance ? self : object_getClass(self)
        
        guard let originalMethod = class_getMethod(cls, originalSelector, methodType) else {
            throw RuntimeKitError.swizzleMethodNotFound
        }
        
        
        guard let swizzledImplementation = imp_implementationWithBlock(block) else {
            throw RuntimeKitError.unableToCreateMethodImplmentationFromBlock
        }
        
        method_setImplementation(originalMethod, swizzledImplementation)
        
    }
}


private func class_getMethod(_ cls: Swift.AnyClass!, _ name: Selector!, _ methodType: MethodType) -> Method! {
    switch methodType {
    case .instance: return class_getInstanceMethod(cls, name)
    case .class: return class_getClassMethod(cls, name)
    }
}
