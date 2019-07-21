//
//  NSString.swift
//  BabyBee
//
//  Created by v.vasilenko on 01.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

extension String {
    func pluralForm(_ n: Int, form1: String, form2: String, form3: String) -> String
    {
        let n = n % 100;
        let n1 = n % 10;
        
        if (n > 10 && n < 20) {
            return form3;
        }
        
        if (n1 > 1 && n1 < 5) {
            return form2;
        }
        
        if (n1 == 1) {
            return form1;
        }
        return form3;
    }
    
    func convertDateComponentsToPluralDate( components: DateComponents ) -> String {
        
        var years = 0, months = 0, days = 0
        if let year = components.year {
            years = year
        }
        if let month = components.month {
            months = month
        }
        if let day = components.day {
            days = day
        }
        
        let pluralMonths = String().pluralForm(months, form1: "месяц", form2: "месяца", form3: "месяцев")
        let pluralDays = String().pluralForm(days, form1: "день", form2: "дня", form3: "дней")
        let pluralYears = String().pluralForm(years, form1: "годик", form2: "годика", form3: "годиков")
        
        var resultString = ""
        if years > 0 {
            resultString += "\(years) \(pluralYears)"
        }
        if years > 0 && months > 0 && days == 0{
            resultString += " и "
        } else if years > 0 && months > 0 {
            resultString += " "
        }
        if months > 0 {
            resultString += "\(months) \(pluralMonths)"
        }
        if (months > 0 || years > 0) && days > 0  {
            resultString += " и "
        }
        if days > 0 {
            resultString += "\(days) \(pluralDays)"
        }
        return resultString
    }
}
