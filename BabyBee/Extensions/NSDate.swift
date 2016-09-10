//
//  File.swift
//  BabyBee
//
//  Created by v.vasilenko on 31.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

extension NSDate {
    func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
    
    func convertDateToGOSTDateString() -> String {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "dd_MM_yyyy"
        return fmt.stringFromDate(self);
    }
    
    func numberOfMonthsUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Month, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Month, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Month, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
    
    func numberOfMonthsAndDaysToTime(toDateTile: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let components = calendar.components([.Day, .Month, .Year], fromDate: self, toDate: toDateTile, options: [])
        
        return components
    }
}