//
//  Runtime.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation

public enum RuntimeKitError: Error {
    case methodNotFound
    case unableToCreateMethodImplmentationFromBlock
    case classnameAlreadyTaken
    case unableToCreateClass
    case protocolAlreadyExists
    case unableToCreateProtocol
}

public struct Runtime { }
