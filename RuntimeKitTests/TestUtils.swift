//
//  TestUtils.swift
//  RuntimeKit
//
//  Created by Lukas Kollmer on 01.04.17.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//

import Foundation

func dayOfTheDoctor() -> NSDate {
    var dateComponents = DateComponents()
    dateComponents.year = 2013
    dateComponents.month = 11
    dateComponents.day = 23
    dateComponents.hour = 19
    dateComponents.minute = 50
    dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
    
    return NSCalendar.current.date(from: dateComponents)! as NSDate
}
