//
//  Methods.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 30.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC


public struct ObjCMethod {
    let name: String
    let selector: Selector
    let type: MethodType
    
    var returnType: String {
        return String(cString: method_copyReturnType(_method))
    }
    
    var numberOfArguments: Int {
        return Int(method_getNumberOfArguments(_method))
    }
    
    var argumentTypes: [String] {
        var argTypes = [String]()
        for i in 0..<numberOfArguments {
            argTypes.append(String(cString: method_copyArgumentType(_method, UInt32(i))))
        }
        
        return argTypes
    }
    
    var implementation: IMP {
        return method_getImplementation(_method)
    }
    
    let _method: Method
    
    init(_ method: Method, type: MethodType) {
        self._method = method
        self.type = type
        self.selector = method_getName(method)
        self.name = NSStringFromSelector(self.selector)
    }
}


public extension NSObject {
    public static var instanceMethods: [ObjCMethod] {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(self.classForCoder(), &count)
        
        var methods = [ObjCMethod]()
        
        for i in 0..<count {
            guard let method = methodList.unsafelyUnwrapped[Int(i)] else { continue }
            
            methods.append(ObjCMethod(method, type: .instance))
        }
        
        return methods
    }
    
    public static var classMethods: [ObjCMethod] {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(object_getClass(self), &count)
        
        var methods = [ObjCMethod]()
        
        for i in 0..<count {
            guard let method = methodList.unsafelyUnwrapped[Int(i)] else { continue }
            
            methods.append(ObjCMethod(method, type: .class))
        }
        
        return methods
    }
}
