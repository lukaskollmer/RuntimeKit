//
//  Protocols.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

/// struct describing a method for a protocol
public struct ObjCMethodDescription {
    /// The method's name
    let name: Selector
    
    /// The method's return type
    let returnType: ObjCTypeEncoding
    
    /// The method's argument types
    let argumentTypes: [ObjCTypeEncoding]
    
    /// `MethodType` case determining whether the method is an instance method or a class method
    let methodType: MethodType
    
    /// Boolean determining whether the method is required
    var isRequired = false
    
    /// The method's encoding
    var encoding: [CChar] {
        return TypeEncoding(returnType, argumentTypes)
    }
    
    /// Create a new `ObjCMethodDescription` instance
    ///
    /// - Parameters:
    ///   - name: The method's name
    ///   - returnType: The method's return type
    ///   - argumentTypes: The method's argument types
    ///   - methodType: `MethodType` case determining whether the method is an instance method or a class method
    ///   - isRequired: Boolean determining whether the method is required
    init(_ name: Selector, returnType: ObjCTypeEncoding = .void, argumentTypes: [ObjCTypeEncoding] = [.object, .selector], methodType: MethodType, isRequired: Bool = false) {
        self.name = name
        self.returnType = returnType
        self.argumentTypes = argumentTypes
        self.methodType = methodType
    }
}

public extension Runtime {
    /// Returns a specified protocol
    ///
    /// - Parameter name: The name of a protocol.
    /// - Returns: The protocol named `name`, or `nil` if no protocol named name could be found
    public static func getProtocol(_ name: String) -> Protocol? {
        return objc_getProtocol(name.cString(using: .utf8)!)
    }
    
    /// Creates a new protocol instance.
    ///
    /// - Parameters:
    ///   - name: The name of the protocol you want to create.
    ///   - methods: The methods you want to add to the new protocol
    /// - Returns: A new protocol instance
    /// - Throws: `RuntimeKitError.protocolAlreadyExists` if a protocol with the same name already exists, `RuntimeKitError.unableToCreateProtocol` if there was an error creating the protocol
    public static func createProtocol(_ name: String, methods: [ObjCMethodDescription]) throws -> Protocol {
        guard Runtime.getProtocol(name) == nil else {
            throw RuntimeKitError.protocolAlreadyExists
        }
        
        guard let newProtocol = objc_allocateProtocol(name.cString(using: .utf8)!) else {
            throw RuntimeKitError.unableToCreateProtocol
        }
        
        methods.forEach {
            protocol_addMethodDescription(newProtocol, $0.name, $0.encoding, $0.isRequired, $0.methodType == .instance)
        }
        
        objc_registerProtocol(newProtocol)
        
        return newProtocol
    }
}
