//
//  Protocols.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

public extension Runtime {
    public static func getProtocol(_ name: String) -> Protocol? {
        return objc_getProtocol(name.cString(using: .utf8))
    }
    
    public static func createProtocol(_ name: String) throws -> Protocol {
        guard Runtime.getProtocol(name) == nil else {
            throw RuntimeKitError.protocolAlreadyExists
        }
        
        return objc_allocateProtocol(name.cString(using: .utf8))
    }
}
