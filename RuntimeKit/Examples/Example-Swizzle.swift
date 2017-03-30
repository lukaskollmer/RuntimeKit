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
    
    func xxx_timeIntervalSinceNow() -> TimeInterval {
        return 777
    }
    
}


extension Examples {
    static func swizzle() {
        
        // -[NSDate addingTimeInterval:]
        
        //try! NSDate.swizzle(#selector(NSDate.addingTimeInterval(_:)), with: #selector(NSDate.xxx_addingTimeInterval(_:)))
        
        
        let addingTimeInterval_block: @convention(block) (Any, Selector, TimeInterval) -> NSDate = { (_self, _sel, _ti) in
            print("adding time intervl")
            return _self as! NSDate
        }
        
        try! NSDate.replace(#selector(NSDate.addingTimeInterval(_:)), withBlock: addingTimeInterval_block)
        
        let date = NSDate()
        print(date.timeIntervalSince(date.addingTimeInterval(100) as Date))
        
        
        // -[NSDate timeIntervalSinceNow]
        
        print("\n\n")
        
        let block: @convention(block) (NSDate, Selector) -> TimeInterval = { (_self, _sel) -> TimeInterval in
            print("hey")
            return 666
        }
        
        try! NSDate.replace(#selector(getter: NSDate.timeIntervalSinceNow), withBlock: block)
        
        print(NSDate.distantPast.timeIntervalSinceNow)
    }
}
