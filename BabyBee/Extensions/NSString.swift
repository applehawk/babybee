//
//  NSString.swift
//  BabyBee
//
//  Created by v.vasilenko on 01.09.16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import Foundation

extension String {
    func pluralForm(n:Int, form1:String, form2:String, form3:String) -> String
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
    
    func convertDateComponentsToPluralDate( components: NSDateComponents ) -> String {
        let pluralMonths = String().pluralForm(components.month, form1: "месяц", form2: "месяца", form3: "месяцев")
        let pluralDays = String().pluralForm(components.day, form1: "день", form2: "дня", form3: "дней")
        let pluralYears = String().pluralForm(components.year, form1: "годик", form2: "годика", form3: "годиков")
        
        var resultString = ""
        if components.year > 0 {
            resultString += "\(components.year) \(pluralYears)"
        }
        if components.year > 0 && components.month > 0 && components.day == 0{
            resultString += " и "
        } else if components.year > 0 && components.month > 0 {
            resultString += " "
        }
        if components.month > 0 {
            resultString += "\(components.month) \(pluralMonths)"
        }
        if (components.month > 0 || components.year > 0) && components.day > 0  {
            resultString += " и "
        }
        if components.day > 0 {
            resultString += "\(components.day) \(pluralDays)"
        }
        return resultString
    }
}