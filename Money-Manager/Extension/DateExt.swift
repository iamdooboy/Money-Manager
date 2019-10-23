//
//  DateExt.swift
//  Money-Manager
//
//  Created by Duy Le on 7/26/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation

extension Foundation.Date {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let strYear = dateFormatter.string(from: self)
        return strYear
    }
    
    func getYearInShortFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY"
        let strYear = dateFormatter.string(from: self)
        return strYear
    }
    
    var startOfWeek: Foundation.Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeek: Foundation.Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
    
    var startOfMonth: Foundation.Date? {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: DateComponents(day: 0), to: self)!
        let range: Range <Int>
        let first: Foundation.Date
        
        range = calendar.range(of: .day, in: .month, for: date)! //month
        
        var firstDayComponents = calendar.dateComponents([.year, .month], from: date)
        firstDayComponents.day = range.lowerBound
        first = calendar.date(from: firstDayComponents)!
        return first
    }
    
    var endOfMonth: Foundation.Date? {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: DateComponents(day: 0), to: self)!
        let range: Range <Int>
        let last: Foundation.Date
        
        range = calendar.range(of: .day, in: .month, for: date)! //month
        
        var lastDayComponents = calendar.dateComponents([.year, .month], from: date)
        lastDayComponents.day = range.upperBound - 1
        last = calendar.date(from: lastDayComponents)!
        
        return last
    }
    
    var startOfYear: Foundation.Date? {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: DateComponents(day: 0), to: self)!
        let first: Foundation.Date

        let yearRange = calendar.range(of: .month, in: .year, for: date)! //year
        
        var firstDayComponents = calendar.dateComponents([.year, .month], from: date)
        
        firstDayComponents.month = yearRange.lowerBound
        first = calendar.date(from: firstDayComponents)!
        
        return first
    }
    
    var endOfYear: Foundation.Date? {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: DateComponents(day: 0), to: self)!
        let last: Foundation.Date
        
        let yearRange = calendar.range(of: .month, in: .year, for: date)! //year
        let dayRange = calendar.range(of: .day, in: .month, for: date)! //day

        var lastDayComponents = calendar.dateComponents([.year, .month], from: date)
        
        lastDayComponents.month = yearRange.upperBound - 1
        lastDayComponents.day = dayRange.upperBound - 1
        last = calendar.date(from: lastDayComponents)!
        
        return last
    }
    
    /// Returns a Date with the specified days added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Foundation.Date {
        var targetDay: Foundation.Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    
    /// Returns a Date with the specified days subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Foundation.Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }
    
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
