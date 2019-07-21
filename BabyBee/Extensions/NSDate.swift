//
//  File.swift
//  BabyBee
//
//  Created by v.vasilenko on 31.08.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

extension Date {
    func numberOfDaysUntilDateTime(toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let difference = calendar.dateComponents([.day], from: self, to: toDateTime)
        
        /*
         var fromDate: Date?, toDate: Date?
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])*/
        
        return difference.day!
    }
    
    func convertDateToGOSTDateString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd_MM_yyyy"
        return fmt.string(from: self)
    }
    
    func numberOfMonthsUntilDateTime(toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        /*
        var fromDate: NSDate?, toDate: NSDate?
        calendar.rangeOfUnit(.Month, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Month, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Month, fromDate: fromDate!, toDate: toDate!, options: [])*/
        
        let difference = calendar.dateComponents([.month], from: self, to: toDateTime)
        
        return difference.month!
    }
    
    func numberOfMonthsAndDaysToTime(toDateTile: Date, inTimeZone timeZone: TimeZone? = nil) -> DateComponents {
        
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        /*
        let components = calendar.components([.Day, .Month, .Year], fromDate: self, toDate: toDateTile, options: [])*/
        let components = calendar.dateComponents([.day, .month, .year], from: self, to: toDateTile)
        
        return components
    }
}
