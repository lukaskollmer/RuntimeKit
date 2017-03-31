//
//  Protocols.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public struct ObjCMethodDescription {
    let name: Selector
    let returnType: ObjCTypeEncoding
    let argumentTypes: [ObjCTypeEncoding]
    let methodType: MethodType
    
    var isRequired = false
    
    var encoding: [CChar] {
        return TypeEncoding(returnType, argumentTypes)
    }
    
    init(_ name: Selector, returnType: ObjCTypeEncoding = .void, argumentTypes: [ObjCTypeEncoding] = [.object, .selector], methodType: MethodType, isRequired: Bool = false) {
        self.name = name
        self.returnType = returnType
        self.argumentTypes = argumentTypes
        self.methodType = methodType
    }
}

public extension Runtime {
    public static func getProtocol(_ name: String) -> Protocol? {
        return objc_getProtocol(name.cString(using: .utf8))
    }
    
    public static func createProtocol(_ name: String, methods: [ObjCMethodDescription]) throws -> Protocol {
        guard Runtime.getProtocol(name) == nil else {
            throw RuntimeKitError.protocolAlreadyExists
        }
        
        guard let newProtocol = objc_allocateProtocol(name.cString(using: .utf8)) else {
            throw RuntimeKitError.unableToCreateProtocol
        }
        
        methods.forEach {
            protocol_addMethodDescription(newProtocol, $0.name, $0.encoding, $0.isRequired, $0.methodType == .instance)
        }
        
        objc_registerProtocol(newProtocol)
        
        return newProtocol
    }
}
