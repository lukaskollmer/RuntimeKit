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
    public func setAssociatedObject<T>(_ value: T?, forKey key: AssociatedObjectKey<T>, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, key.value, value, policy)
    }
    
    public func getAssociatedObject<T>(forKey key: AssociatedObjectKey<T>) -> T? {
        return objc_getAssociatedObject(self, key.value) as? T
    }
}

