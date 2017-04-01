//
//  Methods.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 30.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC


/// An Objective-C method
public struct ObjCMethodInfo {
    /// The method's name
    public let name: String
    
    /// The method's selector
    public let selector: Selector
    
    /// The method's type (whether it's an instace method or a class method)
    public let type: MethodType
    
    /// A String describing the method's return type
    public var returnType: ObjCTypeEncoding {
        return ObjCTypeEncoding(rawValue: String(cString: method_copyReturnType(_method)))!
    }
    
    /// Number of arguments accepted by the method
    public var numberOfArguments: Int {
        return Int(method_getNumberOfArguments(_method))
    }
    
    /// The method's argument types
    public var argumentTypes: [String] {
        var argTypes = [String]()
        for i in 0..<numberOfArguments {
            argTypes.append(String(cString: method_copyArgumentType(_method, UInt32(i))))
        }
        
        return argTypes
    }
    
    /// The method's implementation
    public var implementation: IMP {
        return method_getImplementation(_method)
    }
    
    public let _method: Method
    
    /// Create a new ObjCMethod instance from a `Method` object and a `MethodType` case
    ///
    /// - Parameters:
    ///   - method: The actual ObjC method
    ///   - type: The method's type
    init(_ method: Method, type: MethodType) {
        self._method = method
        self.type = type
        self.selector = method_getName(method)
        self.name = NSStringFromSelector(self.selector)
    }
}


public extension NSObject {
    /// An object's instance methods
    public static var instanceMethods: [ObjCMethodInfo] {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(self.classForCoder(), &count)
        
        return ObjCMethodArrayFromMethodList(methodList, count, .instance)
    }
    
    /// An object's class methods
    public static var classMethods: [ObjCMethodInfo] {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(object_getClass(self), &count)
        
        return ObjCMethodArrayFromMethodList(methodList, count, .class)
    }
    
    public static func methodInfo(for: Selector, type: MethodType) throws -> ObjCMethodInfo {
        let cls: AnyClass = type == .instance ? self : object_getClass(self)
        
        guard let method = class_getMethod(cls, `for`, type) else {
            throw RuntimeKitError.methodNotFound
        }
        
        return ObjCMethodInfo(method, type: type)
    }
}

fileprivate func ObjCMethodArrayFromMethodList(_ methodList: UnsafeMutablePointer<Method?>?, _ count: UInt32, _ methodType: MethodType) -> [ObjCMethodInfo] {
    var methods = [ObjCMethodInfo]()
    
    for i in 0..<count {
        guard let method = methodList.unsafelyUnwrapped[Int(i)] else { continue }
        
        methods.append(ObjCMethodInfo(method, type: methodType))
    }
    
    return methods
}
