//
//  Properties.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public struct ObjCProperty {
    public var name: String {
        return String(cString: property_getName(property))
    }
    
    public let property: objc_property_t
    
    init(_ property: objc_property_t) {
        self.property = property
    }
}

public extension NSObject {
    public static var properties: [ObjCProperty] {
        var count: UInt32 = 0
        let propertyList = class_copyPropertyList(self, &count)
        
        var properties = [ObjCProperty]()
        
        for i in 0..<count {
            guard let property = propertyList.unsafelyUnwrapped[Int(i)] else { continue }
            
            properties.append(ObjCProperty(property))
        }
        
        return properties
    }
}
