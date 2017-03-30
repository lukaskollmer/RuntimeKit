//
//  Example-AssociatedObject.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 30/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation


extension AssociatedObjectKeys {
    static let name = AssociatedObjectKey<NSString>("name")
    static let age  = AssociatedObjectKey<Int>("age")
}

fileprivate class Person: NSObject { }

extension Examples {
    static func associatedObject() {
        let me = Person()
        
        me.setAssociatedObject("lukas", forKey: .name)
        me.setAssociatedObject(18, forKey: .age)
        
        if let name = me.getAssociatedObject(forKey: .name) {
            print(name)
        }
        
        if let age = me.getAssociatedObject(forKey: .age) {
            print(age)
        }

    }
}
