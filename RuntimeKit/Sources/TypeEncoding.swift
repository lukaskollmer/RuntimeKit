//
//  TypeEncoding2.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 22.04.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation


func TypeEncoding(_ returnType: ObjCTypeEncoding, _ argumentTypes: [ObjCTypeEncoding]) -> [CChar] {
    let argTypes = argumentTypes.map { $0.rawValue }.joined()
    
    return returnType.rawValue.appending(argTypes).cString(using: .utf8)!
}


/// Objective-C type encoding
///
/// - int: Int (i)
/// - float: Float (f)
/// - double: Double (d)
/// - bool: Bool (B)
/// - void: void (v)
/// - object: Object (@) (The object's type is passed along as the associated value)
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
/// - `struct`: a c struct
/// - unknown: ? (The unknown type encoding is passed along as the associated value)
public enum ObjCTypeEncoding {
    case int
    case float
    case double
    case bool
    
    case void
    case object
    case `class`
    case selector
    
    case char
    case short
    case characterString
    
    case longLong
    case unsignedChar
    case unsignedInt
    case unsignedShort
    case unsignedLong
    case unsignedLongLong
    
    case `struct`(String) // TODO associated value should be some object describing the struct
    
    case unknown(String)
    
    
    public init(_ encoding: String) {
        switch encoding {
        case "i": self = .int
        case "f": self = .float
        case "d": self = .double
        case "B": self = .bool
        
        case "v": self = .void
        case "#": self = .class
        case ":": self = .selector
        case "@": self = .object
        
        case "c": self = .char
        case "s": self = .short
        case "*": self = .characterString
        
        case "q": self = .longLong
        case "C": self = .unsignedChar
        case "I": self = .unsignedInt
        case "S": self = .unsignedShort
        case "L": self = .unsignedLong
        case "Q": self = .unsignedLongLong
            
        default:
            if encoding.hasPrefix("{") && encoding.hasSuffix("}") {
                self = .struct(encoding)
                break
            }
            self = .unknown(encoding)
        }
    }

}

public extension ObjCTypeEncoding {
    public var rawValue: String {
        switch self {
        case .int:      return "i"
        case .float:    return "f"
        case .double:   return "d"
        case .bool:     return "B"
            
        case .void:     return "v"
        case .`class`:  return "#"
        case .selector: return ":"
            
        case .object(_):
            return "@"
            
        case .char:             return "c"
        case .short:            return "s"
        case .characterString:  return "*"
            
        case .longLong:         return "q"
        case .unsignedChar:     return "iC"
        case .unsignedInt:      return "I"
        case .unsignedShort:    return "S"
        case .unsignedLong:     return "L"
        case .unsignedLongLong: return "Q"
            
        case .`struct`(let encoding):
            return encoding
            
        case .unknown(_):
            // TODO should the associated value be returned instead???
            return "?"

        }
    }
}

extension ObjCTypeEncoding : Equatable {}

public func ==(lhs: ObjCTypeEncoding, rhs: ObjCTypeEncoding) -> Bool {
    switch (lhs, rhs) {
    case (.int, .int):          return true
    case (.float, .float):      return true
    case (.double, .double):    return true
        
    case (.void, .void):            return true
    case (.`class`, .`class`):      return true
    case (.selector, .selector):    return true
    case (.object, .object):        return true
        
    case (.char, .char):    return true
    case (.short, .short):  return true
    case (.characterString, .characterString): return true
        
    case (.longLong, .longLong):                    return true
    case (.unsignedChar, .unsignedChar):            return true
    case (.unsignedInt, .unsignedInt):              return true
    case (.unsignedShort, .unsignedShort):          return true
    case (.unsignedLong, .unsignedLong):            return true
    case (.unsignedLongLong, .unsignedLongLong):    return true
        
    case let (.`struct`(type1), .`struct`(type2)):
        return type1 == type2
    case let (.unknown(encoding1), .unknown(encoding2)):
        return encoding1 == encoding2
        
    default: return false
    }
}
