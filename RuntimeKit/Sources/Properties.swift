//
//  Properties.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

// Reference: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html


/// Struct describing an Objective-C property
public struct ObjCPropertyDescription: CustomStringConvertible {
    /// The property's name
    public var name: String {
        return String(cString: property_getName(property))
    }
    
    public let property: objc_property_t
    
    public private(set) var typeEncoding: ObjCTypeEncoding = .unknown
    
    public private(set) var type: NSObject.Type?
    
    /// The property is read-only (readonly).
    public private(set) var isReadOnly = false
    
    /// The property is a copy of the value last assigned (copy).
    public private(set) var isCopy = false
    
    /// The property is a reference to the value last assigned (retain).
    public private(set) var isRetain = false
    
    /// The property is non-atomic (nonatomic).
    public private(set) var isNonatomic = false
    
    /// The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
    public private(set) var customGetter: String?
    
    /// The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
    public private(set) var customSetter: String?
    
    /// The property is dynamic (@dynamic).
    public private(set) var isDynamic = false
    
    /// The property is a weak reference (__weak).
    public private(set) var isWeak = false
    
    /// The property is eligible for garbage collection.
    public private(set) var isEligibleForGarbageCollection = false
    
    /// Specifies the type using old-style encoding.
    public private(set) var oldStyleTypeEncoding: String? = nil
    
    
    init(_ property: objc_property_t) {
        self.property = property
        
        ///print(String(cString: property_getAttributes(property)))
        
        var count: UInt32 = 0
        let attributeList = property_copyAttributeList(property, &count)
        
        for i in 0..<count {
            let attribute = attributeList.unsafelyUnwrapped[Int(i)]
            
            let name = String(cString: attribute.name)
            let value = String(cString: attribute.value)
            
            switch name {
            case "T":
                /**
                 TODO: This should detect:
                 - [x] objects (id) and their objc class
                 - [ ] structs and maybe even create an object describing the struct
                 - [ ] other type encoding codes like 'r' for const, etc (https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html)
                 */
                var value = value
                if value.hasPrefix("@\"") && value.hasSuffix("\"") {
                    value = value
                        .replacingOccurrences(of: "@\"", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                }
                if (Runtime.classExists(value)) {
                    self.typeEncoding = .object
                    self.type = Runtime.getClass(value)
                } else {
                    self.typeEncoding = ObjCTypeEncoding(rawValue: value) ?? .unknown
                }
            case "R":
                self.isReadOnly = true
            case "C":
                self.isCopy = true
            case "&":
                self.isRetain = true
            case "N":
                self.isNonatomic = true
            case "G":
                self.customGetter = value
            case "S":
                self.customSetter = value
            case "D":
                self.isDynamic = true
            case "W":
                self.isWeak = true
            case "P":
                self.isEligibleForGarbageCollection = true
            case "t":
                self.oldStyleTypeEncoding = value // TODO this is not tested
            default: break
            }
        }
        
        free(attributeList)

    }
    
    public var description: String {
        let name = String(cString: property_getName(property))
        return "[objc_property name: \(name)]"
    }
}

public extension NSObject {
    /// Get an object's properties
    public static var properties: [ObjCPropertyDescription] {
        var count: UInt32 = 0
        let propertyList = class_copyPropertyList(self, &count)
        
        var properties = [ObjCPropertyDescription]()
        
        for i in 0..<count {
            guard let property = propertyList.unsafelyUnwrapped[Int(i)] else { continue }
            
            properties.append(ObjCPropertyDescription(property))
        }
        
        return properties
    }
    
    public func getProperty<T>(_ property: ObjCPropertyDescription) -> T! {
        let key = property.customGetter ?? property.name
        
        return self.getProperty(key)
    }
    
    public func getProperty<T>(_ name: String) -> T! {
        return self.value(forKey: name) as? T
    }
}
