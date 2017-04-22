//
//  iVars.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 22.04.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public struct ObjCiVarDescription: CustomStringConvertible {
    public let iVar: Ivar
    
    public var name: String {
        return String(cString: ivar_getName(iVar))
    }
    
    public var offset: Int {
        return ivar_getOffset(iVar)
    }
    
    /// This is always .unknown because `ivar_getTypeEncoding` returns an empty string in swift
    public let typeEncoding = ObjCTypeEncoding.unknown("?")
    
    init(_ iVar: Ivar) {
        self.iVar = iVar
    }
    
    public var description: String {
        return "[Ivar name: \(self.name)]"
    }
}


public extension NSObject {
    /// Get an object's iVars
    public static var iVars: [ObjCiVarDescription] {
        var count: UInt32 = 0
        let iVarList = class_copyIvarList(self, &count)
        
        var iVars = [ObjCiVarDescription]()
        
        for i in 0..<count {
            guard let ivar = iVarList.unsafelyUnwrapped[Int(i)] else { continue }
            
            iVars.append(ObjCiVarDescription(ivar))
        }
        
        free(iVarList)
        
        return iVars
    }
    
    public func getiVar<T>(_ iVar: ObjCiVarDescription) -> T! {
        return self.getiVar(iVar.name)
    }
    
    public func getiVar<T>(_ name: String) -> T! {
        return self.value(forKey: name) as? T
    }
}
