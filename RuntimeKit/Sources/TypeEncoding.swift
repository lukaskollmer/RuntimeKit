//
//  TypeEncoding.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation

/// Objective-C type encoding
///
/// - int: Int (i)
/// - float: Float (f)
/// - double: Double (d)
/// - bool: Bool (B)
/// - void: void (v)
/// - object: Objecy (@)
/// - `class`: Class (#)
/// - selector: Selector (:)
/// - char: Char (c)
/// - short: Short (s)
/// - characterString: char* (*)
/// - longLong: long long (q)
/// - unsignedChar: unsigned char (C)
/// - unsignedInt: unsigned int (I)
/// - unsignedShort: unsigned short (S)
/// - unsignedLong: unsigned long (L)
/// - unsignedLongLong: unsigned long long (Q)
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
