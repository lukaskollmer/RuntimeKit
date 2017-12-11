//
//  AddMethod.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public extension NSObject {
    
    /// Add a new method to a class
    ///
    /// - Parameters:
    ///   - newSelector: The new method's selector
    ///   - implementationBlock: A block to be used as the method's implementation
    ///   - methodType: `MethodType` determining whether the method is an instance method or a class method
    ///   - returnType: The method's return type
    ///   - argumentTypes: The method's argument types
    /// - Returns: `true` if the method was added successfully, otherwise `false`
    /// - Throws: `RuntimeKitError.unableToCreateMethodImplmentationFromBlock` if there was an error turning the block into a method implementation
    @discardableResult
    public static func addMethod(_ newSelector: Selector, implementation implementationBlock: Any, methodType: MethodType = .instance, returnType: ObjCTypeEncoding = .void, argumentTypes: [ObjCTypeEncoding] = [.object, .selector]) throws -> Bool {
        
        let cls: AnyClass = methodType == .instance ? self : object_getClass(self)!
        
        let encoding = TypeEncoding(returnType, argumentTypes)
        
        let implementation = imp_implementationWithBlock(implementationBlock)
        
        return class_addMethod(cls, newSelector, implementation, encoding)
    }
}
