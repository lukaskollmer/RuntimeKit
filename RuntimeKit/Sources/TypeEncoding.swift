//
//  TypeEncoding.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation

public enum ObjCTypeEncoding: String {
    case int    = "i"
    case float  = "f"
    case double = "d"
    case bool   = "B"
    
    case void     = "v"
    case object   = "@"
    case `class`  = "#"
    case selector = ":"

    case char            = "c"
    case short           = "s"
    case characterString = "*"
    
    case longLong         = "q"
    case unsignedChar     = "C"
    case unsignedInt      = "I"
    case unsignedShort    = "S"
    case unsignedLong     = "L"
    case unsignedLongLong = "Q"
}


func TypeEncoding(_ returnType: ObjCTypeEncoding, _ argumentTypes: [ObjCTypeEncoding]) -> [CChar] {
    let argTypes = argumentTypes.map { $0.rawValue }.joined()
    
    return returnType.rawValue.appending(argTypes).cString(using: .utf8)!
}
