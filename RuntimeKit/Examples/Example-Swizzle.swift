//
//  Example-Swizzle.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 30/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation


extension NSDate {
    func xxx_addingTimeInterval(_ ti: TimeInterval) -> NSDate {
        print("adding ti \(ti)")
        return self.xxx_addingTimeInterval(ti)
    }
    
}


extension Examples {
    static func swizzle() {
        
        try! NSDate.swizzle(#selector(NSDate.addingTimeInterval(_:)), with: #selector(NSDate.xxx_addingTimeInterval(_:)))
        
        let date = NSDate()
        print(date.timeIntervalSince(date.addingTimeInterval(100) as Date))
    }
}
