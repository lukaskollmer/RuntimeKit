//
//  AssociatedObject.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 30/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public class AssociatedObjectKeys {
    fileprivate init () {}
}

public class AssociatedObjectKey<T>: AssociatedObjectKeys {
    fileprivate let value: [CChar]
    
    public init(_ key: String) {
        self.value = key.cString(using: .utf8)!
    }
}


public extension NSObject {
    /// Sets an associated value for a given object using a given key and association policy.
    ///
    /// - Parameters:
    ///   - value: The value to associate with the key key for object. Pass `nil` to clear an existing association.
    ///   - key: The key for the association
    ///   - policy: The policy for the association. Default value is OBJC_ASSOCIATION_RETAIN_NONATOMIC
    public func setAssociatedObject<T>(_ value: T?, forKey key: AssociatedObjectKey<T>, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, key.value, value, policy)
    }
    
    /// Returns the value associated with a given object for a given key.
    ///
    /// - Parameter key: The key for the association
    /// - Returns: The value associated with the key `key` for the object.
    public func getAssociatedObject<T>(forKey key: AssociatedObjectKey<T>) -> T? {
        return objc_getAssociatedObject(self, key.value) as? T
    }
}

