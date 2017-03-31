//
//  Classes.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 31.03.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation
import ObjectiveC

struct ObjCClass {
    let name: String
    let `class`: AnyClass
    let protocols: [Protocol]
    
    init(_ `class`: AnyClass) {
        self.name = String(cString: class_getName(`class`))
        self.class = `class`
        self.protocols = [] // TODO
    }
}


extension Runtime {
    static var allClasses: [ObjCClass] {
        var count: UInt32 = 0
        let classList = objc_copyClassList(&count)
        
        var allClasses = [ObjCClass]()
        
        for i in 0..<count {
            guard let `class` = classList.unsafelyUnwrapped[Int(i)] else { continue }
            allClasses.append(ObjCClass(`class`))
        }
        
        return allClasses
    }
}
