//
//  PerformSelector.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 01.04.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public class ObjCMethodCallRequests {}

public class ObjCMethodCallRequest<T>: ObjCMethodCallRequests {
    let selector: Selector
    
    public init(_ name: String) {
        self.selector = NSSelectorFromString(name)
    }
}

public extension NSObject {
    
    
    public static func perform<T>(_ methodCall: ObjCMethodCallRequest<T>, _ args: Any...) throws -> T! {
        guard args.count <= 2 else {
            throw RuntimeKitError.tooManyArguments
        }
        
        let methodInfo = try! self.methodInfo(for: methodCall.selector, type: .class)
        
        let retval: Unmanaged<AnyObject>? = {
            switch args.count {
            case 1: return self.perform(methodCall.selector, with: args[0])
            case 2: return self.perform(methodCall.selector, with: args[0], with: args[1])
            default: return self.perform(methodCall.selector)
            }
        }()
        
        guard methodInfo.returnType != .void && (T.self != Void.self) else { return Void() as! T }
        
        guard let unwrappedRetval = retval else { return nil }
        
        return unwrappedRetval.takeRetainedValue() as! T
    }
    
    
    
    public func perform<T>(_ methodCall: ObjCMethodCallRequest<T>, _ args: Any...) throws -> T! {
        guard args.count <= 2 else {
            throw RuntimeKitError.tooManyArguments
        }
        
        let methodInfo = try! type(of: self).methodInfo(for: methodCall.selector, type: .instance)
        
        let retval: Unmanaged<AnyObject>? = {
            switch args.count {
            case 1: return self.perform(methodCall.selector, with: args[0])
            case 2: return self.perform(methodCall.selector, with: args[0], with: args[1])
            default: return self.perform(methodCall.selector)
            }
        }()
        
        guard methodInfo.returnType != .void && (T.self != Void.self) else { return Void() as! T }
        
        guard let unwrappedRetval = retval else { return nil }
        
        return unwrappedRetval.takeRetainedValue() as! T
    }
}


