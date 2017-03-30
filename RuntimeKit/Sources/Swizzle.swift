//
//  Swizzle.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 30/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public enum RuntimeKitError: Error {
    case swizzleMethodNotFound
    case unableToCreateMethodImplmentationFromBlock
    case classMethodsNotYetSupported
}

public enum MethodType {
    case instance
    case `class`
}

public extension NSObject {
    public static func swizzle(_ originalSelector: Selector, with swizzledSelector: Selector, methodType: MethodType = .instance) throws {
        
        guard methodType == .instance else {
            throw RuntimeKitError.classMethodsNotYetSupported
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
    
    public static func replace(_ originalSelector: Selector, withBlock block: Any!, methodType: MethodType = .instance) throws {
        
        guard let originalMethod = class_getMethod(self, originalSelector, methodType) else {
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
