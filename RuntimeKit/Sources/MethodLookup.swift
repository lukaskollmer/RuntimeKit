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
    public let name: String
    public let selector: Selector
    public let type: MethodType
    
    public var returnType: String {
        return String(cString: method_copyReturnType(_method))
    }
    
    public var numberOfArguments: Int {
        return Int(method_getNumberOfArguments(_method))
    }
    
    public var argumentTypes: [String] {
        var argTypes = [String]()
        for i in 0..<numberOfArguments {
            argTypes.append(String(cString: method_copyArgumentType(_method, UInt32(i))))
        }
        
        return argTypes
    }
    
    public var implementation: IMP {
        return method_getImplementation(_method)
    }
    
    public let _method: Method
    
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
        
        return ObjCMethodArrayFromMethodList(methodList, count, .instance)
    }
    
    public static var classMethods: [ObjCMethod] {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(object_getClass(self), &count)
        
        return ObjCMethodArrayFromMethodList(methodList, count, .class)
    }
}

fileprivate func ObjCMethodArrayFromMethodList(_ methodList: UnsafeMutablePointer<Method?>?, _ count: UInt32, _ methodType: MethodType) -> [ObjCMethod] {
    var methods = [ObjCMethod]()
    
    for i in 0..<count {
        guard let method = methodList.unsafelyUnwrapped[Int(i)] else { continue }
        
        methods.append(ObjCMethod(method, type: methodType))
    }
    
    return methods
}
