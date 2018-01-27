//
//  LessAboveGlobal.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit

func returnDayStringWith(timestamp: NSNumber) -> String {
    
    let timestampeDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: timestamp))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd"
    let dayStr = dateFormatter.string(from: timestampeDate as Date)
    return dayStr
}

func returnMonthStringWith(timestamp: NSNumber) -> String {
    
    let timestampeDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: timestamp))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM"
    let monthStr = dateFormatter.string(from: timestampeDate as Date)
    return monthStr
}

func returnFullDateStringWith(timestamp: NSNumber) -> String {
    
    let timestampeDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: timestamp))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E, MMM d, yyyy"
    let monthStr = dateFormatter.string(from: timestampeDate as Date)
    return monthStr
}

func returnDayAndMonthStringWith(timestamp: NSNumber) -> String {
    
    let timestampeDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: timestamp))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd,MMM"
    let monthStr = dateFormatter.string(from: timestampeDate as Date)
    return monthStr
}


