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
    
    @discardableResult
    public static func addMethod(_ newSelector: Selector, implementation implementationBlock: Any, methodType: MethodType = .instance, returnType: ObjCTypeEncoding = .void, argumentTypes: [ObjCTypeEncoding] = [.object, .selector]) throws -> Bool {
        
        let cls: AnyClass = methodType == .instance ? self : object_getClass(self)
        
        let encoding = TypeEncoding(returnType, argumentTypes)
        
        guard let implementation = imp_implementationWithBlock(implementationBlock) else {
            throw RuntimeKitError.unableToCreateMethodImplmentationFromBlock
        }
        
        return class_addMethod(cls, newSelector, implementation, encoding)
    }
}
