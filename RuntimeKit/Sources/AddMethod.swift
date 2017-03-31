//
//  AddMethod.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

extension NSObject {
    @discardableResult
    static func addMethod(_ newSelector: Selector, implementation implementationBlock: Any, returnType: ObjCTypeEncoding = .void, argumentTypes: [ObjCTypeEncoding] = [.object, .selector]) throws -> Bool {
        
        let encoding: [CChar] = {
            let argTypes = argumentTypes.map { $0.rawValue }.joined()
            
            return returnType.rawValue.appending(argTypes).cString(using: .utf8)!
        }()
        
        guard let implementation = imp_implementationWithBlock(implementationBlock) else {
            throw RuntimeKitError.unableToCreateMethodImplmentationFromBlock
        }
        
        return class_addMethod(self, newSelector, implementation, encoding)
    }
}
